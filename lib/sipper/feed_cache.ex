defmodule Sipper.FeedCache do
  @path System.tmp_dir! <> "/sipper.cache"
  @ttl_seconds 60 * 10

  def read do
    expire_if_stale

    case File.read(@path) do
      {:ok, feed} -> {:ok, feed}
      _ -> {:nocache, "Sorry…"}
    end
  end

  def write(feed) do
    File.write!(@path, feed)
  end

  defp expire_if_stale do
    if stale? do
      File.rm!(@path)
    end
  end

  defp stale? do
    case File.stat(@path, time: :local) do
      {:ok, info} ->
        modified_secs = info.mtime |> :calendar.datetime_to_gregorian_seconds
        current_secs = :calendar.local_time |> :calendar.datetime_to_gregorian_seconds
        age = current_secs - modified_secs
        age > @ttl_seconds
      _ ->
        # No file, so it's not stale.
        false
    end
  end
end
