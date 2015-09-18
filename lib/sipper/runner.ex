defmodule Sipper.Runner do
  @dir "./downloads"

  @cache_file "/tmp/sipper.cache"
  @cache_ttl_sec 5 * 60

  def run(user, pw) do
    expire_stale_cache

    auth = {user, pw}

    auth
    |> get_feed
    |> parse_feed

    |> Enum.take(3)  # Just for dev.

    |> Enum.each(&download_episode(&1, auth))
  end

  defp expire_stale_cache do
    case File.stat(@cache_file) do
      {:ok, info} ->
        modified_secs = info.mtime |> :calendar.datetime_to_gregorian_seconds
        current_secs = :calendar.local_time |> :calendar.datetime_to_gregorian_seconds
        age = current_secs - modified_secs
        if age > @cache_ttl_sec, do: File.rm!(@cache_file)
    end
  end

  defp get_feed(auth) do
    case File.read(@cache_file) do
      {:ok, cached_feed} ->
        IO.puts "Retrieved feed from cache…"
        cached_feed
      _ ->
        IO.puts "Retrieving feed (wasn't in cache)…"
        feed = Sipper.DpdCartClient.get_feed!(auth)
        File.write!(@cache_file, feed)
        feed
    end
  end

  defp download_episode({title, files}, auth) do
    files |> Enum.each(&download_file(title, &1, auth))
  end

  defp download_file(title, {id, name}, auth) do
    dir = "#{@dir}/#{title}"
    File.mkdir_p!(dir)

    path = "#{dir}/#{name}"

    if File.exists?(path) do
      IO.puts "[ALREADY DOWNLOADED] #{path}"
    else
      IO.puts "[DOWNLOADING] #{name}…"

      download_file({id, name}, path, auth)

      IO.puts "[DONE!] #{name}"
    end
  end

  defp download_file({id, name}, path, auth) do
    data = Sipper.DpdCartClient.get_file!({id, name}, auth)
    File.write!(path, data)
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)
end
