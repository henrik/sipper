defmodule Sipper.Runner do
  def run(config) do
    get_feed(config)
    |> parse_feed
    |> order_by_oldest(config.oldest_first)
    |> limit_to(config.max)
    |> download(config)
  end

  defp get_feed(config) do
    Sipper.FeedDownloader.run(config)
  end

  defp parse_feed(feed) do
    Sipper.FeedParser.parse(feed)
  end

  defp order_by_oldest(episodes, :false), do: episodes
  defp order_by_oldest(episodes, :true), do: episodes |> Enum.reverse

  defp limit_to(episodes, :unlimited), do: episodes
  defp limit_to(episodes, max), do: episodes |> Enum.take(max)

  defp download(episodes, config) do
    Sipper.FileDownloader.run(episodes, config)
  end
end
