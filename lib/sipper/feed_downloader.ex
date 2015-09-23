defmodule Sipper.FeedDownloader do
  def run(config) do
    case Sipper.FeedCache.read do
      {:ok, cached_feed} ->
        IO.puts [IO.ANSI.blue, "[USING CACHED FEED]"]
        cached_feed
      _ ->
        label = [IO.ANSI.magenta, "[GETTING FEED…] ", IO.ANSI.reset]

        Sipper.ProgressBar.render_indeterminate label, fn ->
          feed = Sipper.DpdCartClient.get_feed(config.auth)
          Sipper.FeedCache.write(feed)
          feed
        end
    end
  end
end
