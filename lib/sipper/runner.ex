defmodule Sipper.Runner do
  # Vertical alignment.
  @exists_label "[EXISTS]"
  @get_label    "[GET]   "

  def run(config) do
    get_feed(config.auth)
    |> parse_feed
    |> limit_to(config.max)
    |> download_all(config)
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

  defp download_all(episodes, config) do
    episodes |> Enum.each(&download_episode(&1, config))
    IO.puts "All done!"
  end

  defp download_episode({title, files}, config) do
    files |> Enum.each(&download_file(title, &1, config))
  end

  defp download_file(title, {id, name}, config) do
    dir = "#{config.dir}/#{title}"
    File.mkdir_p!(dir)

    path = "#{dir}/#{name}"

    if File.exists?(path) do
      IO.puts [IO.ANSI.blue, @exists_label, IO.ANSI.reset, " ", path]
    else
      IO.puts [IO.ANSI.magenta, @get_label, IO.ANSI.reset, " ", path]
      Sipper.DpdCartClient.get_file({id, name}, config.auth, callback: &receive_file(path, &1))
    end
  end

  defp receive_file(_path, {:file_progress, acc, total}) do
    Sipper.ProgressBar.print(acc, total)
  end

  defp receive_file(path, {:file_done, data}) do
    File.write!(path, data)
  end
end
