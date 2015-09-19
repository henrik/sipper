defmodule Sipper.Runner do
  def run(config) do
    get_feed(config.auth)
    |> parse_feed
    |> limit_to(config.max)
    |> download(config)
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

  defp download(episodes, config) do
    Sipper.Downloader.run(episodes, config)
  end
end
