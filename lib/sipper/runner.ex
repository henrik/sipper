defmodule Sipper.Runner do
  def run(config) do
    get_feed(config)
    |> parse_feed
    |> change_download_order(config.oldest_first)
    |> ignore_episodes(config.ignore)
    |> skip_until(config.start)
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
    Enum.reject(episodes, fn {title, _} ->
      Enum.any?(ignore_episodes, fn ignored -> String.contains?(title, ignored) end)
    end)
  end

  defp change_download_order(episodes, true),  do: Enum.reverse(episodes)
  defp change_download_order(episodes, false), do: episodes

  defp skip_until(episodes, first) do
    first = first |> String.pad_leading(3, "0")

    Enum.drop_while(episodes, fn {title, _} ->
      not String.contains?(title, first)
    end)
  end

  defp limit_to(episodes, :unlimited), do: episodes
  defp limit_to(episodes, max), do: episodes |> Enum.take(max)

  defp download(episodes, config) do
    Sipper.FileDownloader.run(episodes, config)
  end
end
