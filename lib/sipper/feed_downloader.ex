defmodule Sipper.FeedDownloader do
  def run(config) do
    case Sipper.FeedCache.read do
      {:ok, cached_feed} ->
        IO.puts [IO.ANSI.blue, "[USING CACHED FEED]"]
        cached_feed
      _ ->
        IO.puts [IO.ANSI.magenta, "[GETTING FEED…]"]

        Sipper.ProgressBar.print_indeterminate
        feed = Sipper.DpdCartClient.get_feed(config.auth)
        Sipper.FeedCache.write(feed)
        Sipper.ProgressBar.terminate

        feed
    end
  end
end
