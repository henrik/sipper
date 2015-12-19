defmodule Sipper.Runner do
  def run(config) do
    get_feed(config)
    |> parse_feed
    |> change_download_order(config.oldest_first)
    |> ignore_episodes(config.ignore)
    |> limit_to(config.max)
    |> download(config)
  end

  defp get_feed(config) do
    Sipper.FeedDownloader.run(config)
  end

  defp parse_feed(feed) do
    Sipper.FeedParser.parse(feed)
  end

  defp ignore_episodes(episodes, ignore_episodes) do
    Enum.filter(episodes, fn {title, _} ->
      Enum.all?(ignore_episodes, fn x -> !String.contains?(title, x) end)
    end)
  end

  defp change_download_order(episodes, ascending) do
    cond do
      ascending -> Enum.reverse(episodes)
      true -> episodes
    end
  end

  defp limit_to(episodes, :unlimited), do: episodes
  defp limit_to(episodes, max), do: episodes |> Enum.take(max)

  defp download(episodes, config) do
    Sipper.FileDownloader.run(episodes, config)
  end
end
