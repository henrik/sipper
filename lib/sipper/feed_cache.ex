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
    case File.stat(@path, time: :posix) do
      {:ok, info} ->
        age = current_posix_time - info.mtime
        age > @ttl_seconds
      _ ->
        # No file, so it's not stale.
        false
    end
  end

  defp current_posix_time do
    # Erlang 17 compatibility. Erlang 18: :os.system_time(:seconds)
    {megasecs, secs, _} = :os.timestamp
    megasecs * 1_000_000 + secs
  end
end
