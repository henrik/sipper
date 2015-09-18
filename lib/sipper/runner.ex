defmodule Sipper.Runner do
  @dir "./downloads"

  def run(user, pw, max) do
    auth = {user, pw}

    get_feed(auth)
    |> parse_feed
    |> limit_to(max)
    |> download_all(auth)
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

  defp download_all(episodes, auth) do
    episodes |> Enum.each(&download_episode(&1, auth))
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
      IO.puts "[DOWNLOADING] #{name}…"

      data = Sipper.DpdCartClient.get_file!({id, name}, auth)
      File.write!(path, data)

      IO.puts "[DONE!] #{name}"
    end
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)

  defp limit_to(episodes, :unlimited), do: episodes

  defp limit_to(episodes, max) do
    episodes |> Enum.take(max)
  end
end
