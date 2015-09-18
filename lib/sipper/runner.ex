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
        IO.puts [IO.ANSI.blue, "[USING CACHED FEED]"]
        cached_feed
      _ ->
        IO.puts [IO.ANSI.magenta, "[GET FEED]"]
        feed = Sipper.DpdCartClient.get_feed!(auth)
        Sipper.FeedCache.write(feed)
        feed
    end
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)

  defp limit_to(episodes, :unlimited), do: episodes
  defp limit_to(episodes, max), do: episodes |> Enum.take(max)

  defp download_all(episodes, auth) do
    episodes |> Enum.each(&download_episode(&1, auth))
    IO.puts "All done!"
  end

  defp download_episode({title, files}, auth) do
    files |> Enum.each(&download_file(title, &1, auth))
  end

  defp download_file(title, {id, name}, auth) do
    dir = "#{@dir}/#{title}"
    File.mkdir_p!(dir)

    path = "#{dir}/#{name}"

    if File.exists?(path) do
      IO.puts [IO.ANSI.blue, "[EXISTS]", IO.ANSI.reset, " ", path]
    else
      IO.puts [IO.ANSI.magenta, "[GET]", IO.ANSI.reset, " ", path]
      Sipper.DpdCartClient.get_file({id, name}, auth, callback: &receive_file(path, &1))
    end
  end

  defp receive_file(_path, {:file_progress, acc, total}) do
    print_progress_bar(acc, total)
  end

  defp receive_file(path, {:file_done, data}) do
    IO.puts "\n"
    File.write!(path, data)
  end

  defp print_progress_bar(acc, total) do
    Sipper.ProgressBar.print(acc, total)
  end
end
