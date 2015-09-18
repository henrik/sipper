defmodule Sipper.Runner do
  @dir "./downloads"

  def run(user, pw, max) do
    {:ok, _pid} = Sipper.DownloadServer.start_link

    auth = {user, pw}

    auth
    |> get_feed
    |> parse_feed
    |> limit_to(max)
    |> Enum.each(&download_episode(&1, auth))

    Sipper.DownloadServer.await
  end

  defp get_feed(auth) do
    case Sipper.FeedCache.read do
      {:ok, cached_feed} ->
        IO.puts "Retrieved feed from cache…"
        cached_feed
      _ ->
        IO.puts "Retrieving feed (wasn't in cache)…"
        feed = Sipper.DpdCartClient.get_feed!(auth)
        Sipper.FeedCache.write(feed)
        feed
    end
  end

  defp download_episode({title, files}, auth) do
    files |> Enum.each(&download_file(title, &1, auth))
  end

  defp download_file(title, {id, name}, auth) do
    dir = "#{@dir}/#{title}"
    File.mkdir_p!(dir)

    path = "#{dir}/#{name}"

    if File.exists?(path) do
      IO.puts "[ALREADY DOWNLOADED] #{path}"
    else
      Sipper.DownloadServer.get(path, {id, name}, auth)
    end
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)

  defp limit_to(episodes, :unlimited), do: episodes

  defp limit_to(episodes, max) do
    episodes |> Enum.take(max)
  end
end
