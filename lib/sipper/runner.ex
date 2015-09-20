defmodule Sipper.Runner do
  def run(config) do
    get_feed(config)
    |> parse_feed
    |> limit_to(config.max)
    |> download(config)
  end

  defp get_feed(config) do
    Sipper.FeedDownloader.run(config)
  end

  defp parse_feed(feed) do
    Sipper.FeedParser.parse(feed)
  end

  defp limit_to(episodes, :unlimited), do: episodes
  defp limit_to(episodes, max), do: episodes |> Enum.take(max)

  defp download(episodes, config) do
    Sipper.FileDownloader.run(episodes, config)
  end
end
