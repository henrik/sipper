defmodule Sipper.Downloader do
  @subdomain "elixirsips"
  @feed_url  "https://#{@subdomain}.dpdcart.com/feed"
  @timeout_ms 10_000  # The default 5000 times out sometimes.

  def run(user, pw) do
    IO.puts "Retrieving feed…"

    # Retrieving the feed:
    response = HTTPotion.get(@feed_url, basic_auth: {user, pw}, timeout: @timeout_ms)
    %HTTPotion.Response{body: html, status_code: 200} = response
    IO.puts String.length(html)  # TODO: use it…

    # Downloading a file (id, filename)
    {file_id, file_name} = {"1413", "003_Pattern_Matching.md"}
    url = "https://#{@subdomain}.dpdcart.com/feed/download/#{file_id}/#{file_name}"
    response = HTTPotion.get(url, basic_auth: {user, pw})
    IO.puts response.body
  end
end
