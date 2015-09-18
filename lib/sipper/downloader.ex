defmodule Sipper.Downloader do
  @subdomain "elixirsips"
  @feed_url  "https://#{@subdomain}.dpdcart.com/feed"
  @timeout_ms 10_000  # The default 5000 will time out sometimes.

  @cache_file "/tmp/sipper.cache"
  @cache_ttl_sec 5 * 60

  def run(user, pw) do
    expire_stale_cache

    {user, pw}
    |> get_feed_html
    |> parse_feed

    |> Enum.take(2)  # Just for dev.
    |> IO.inspect

    # Downloading a file (id, filename)
    {file_id, file_name} = {"1413", "003_Pattern_Matching.md"}
    url = "https://#{@subdomain}.dpdcart.com/feed/download/#{file_id}/#{file_name}"
    _response = HTTPotion.get(url, basic_auth: {user, pw})
    #IO.puts response.body
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
        IO.puts "Loaded feed from cache…"
        html
      _ ->
        IO.puts "Retrieving feed…"

        response = HTTPotion.get(@feed_url, basic_auth: auth, timeout: @timeout_ms)
        %HTTPotion.Response{body: html, status_code: 200} = response

        File.write!(@cache_file, html)

        html
    end
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)
end
