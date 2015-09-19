defmodule Sipper.Runner do
  # Vertical alignment.
  @exists_label "[EXISTS]"
  @get_label    "[GET]   "

  def run(user, pw, max, dir) do
    auth = {user, pw}

    get_feed(auth)
    |> parse_feed
    |> limit_to(max)
    |> download_all(auth, dir)
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

  defp download_all(episodes, auth, dir) do
    episodes |> Enum.each(&download_episode(&1, auth, dir))
    IO.puts "All done!"
  end

  defp download_episode({title, files}, auth, dir) do
    files |> Enum.each(&download_file(title, &1, auth, dir))
  end

  defp download_file(title, {id, name}, auth, dir) do
    file_dir = "#{dir}/#{title}"
    File.mkdir_p!(file_dir)

    path = "#{file_dir}/#{name}"

    if File.exists?(path) do
      IO.puts [IO.ANSI.blue, @exists_label, IO.ANSI.reset, " ", path]
    else
      IO.puts [IO.ANSI.magenta, @get_label, IO.ANSI.reset, " ", path]
      Sipper.DpdCartClient.get_file({id, name}, auth, callback: &receive_file(path, &1))
    end
  end

  defp receive_file(_path, {:file_progress, acc, total}) do
    Sipper.ProgressBar.print(acc, total)
  end

  defp receive_file(path, {:file_done, data}) do
    File.write!(path, data)
  end
end
