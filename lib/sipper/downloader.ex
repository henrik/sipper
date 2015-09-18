defmodule Sipper.Downloader do
  @subdomain "elixirsips"
  @feed_url  "https://#{@subdomain}.dpdcart.com/feed"
  @feed_timeout_ms 15_000  # The default 5000 will time out sometimes.
  @file_timeout_ms 1000 * 60 * 60 * 3

  @dir "./downloads"

  @cache_file "/tmp/sipper.cache"
  @cache_ttl_sec 5 * 60

  def run(user, pw) do
    expire_stale_cache

    auth = {user, pw}

    auth
    |> get_feed_html
    |> parse_feed

    |> Enum.take(2)  # Just for dev.

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

  defp get_feed_html(auth) do
    case File.read(@cache_file) do
      {:ok, html} ->
        IO.puts "Retrieved feed from cache…"
        html
      _ ->
        IO.puts "Retrieving feed (nothing is cached)…"

        response = HTTPotion.get(@feed_url, basic_auth: auth, timeout: @feed_timeout_ms)
        %HTTPotion.Response{body: html, status_code: 200} = response

        File.write!(@cache_file, html)

        html
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

      # TODO: Do this in curl to get progress?
      url = "https://#{@subdomain}.dpdcart.com/feed/download/#{id}/#{name}"
      response = HTTPotion.get(url, basic_auth: auth, timeout: @file_timeout_ms)
      %HTTPotion.Response{body: data, status_code: 200} = response

      File.write!(path, data)
      IO.puts "[DONE!] #{name}"
    end
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)
end
