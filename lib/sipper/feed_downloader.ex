defmodule Sipper.FeedDownloader do
  def run(config) do
    case Sipper.FeedCache.read do
      {:ok, cached_feed} ->
        IO.puts "Using cached feed."
        cached_feed
      _ ->
        Sipper.ProgressBar.render_spinner "Getting feed…", "Got feed.", fn ->
          feed = Sipper.DpdCartClient.get_feed(config.auth)
          Sipper.FeedCache.write(feed)
          feed
        end
    end
  end
end
