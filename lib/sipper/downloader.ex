defmodule Sipper.Downloader do
  @subdomain "elixirsips"
  @feed_url  "https://#{@subdomain}.dpdcart.com/feed"
  @timeout_ms 10_000  # The default 5000 will time out sometimes.

  def run(user, pw) do
    {user, pw}
    |> get_feed_html
    |> parse_feed
    |> IO.inspect

    # Downloading a file (id, filename)
    {file_id, file_name} = {"1413", "003_Pattern_Matching.md"}
    url = "https://#{@subdomain}.dpdcart.com/feed/download/#{file_id}/#{file_name}"
    _response = HTTPotion.get(url, basic_auth: {user, pw})
    #IO.puts response.body
  end

  defp get_feed_html(auth) do
    IO.puts "Retrieving feed…"

    response = HTTPotion.get(@feed_url, basic_auth: auth, timeout: @timeout_ms)
    %HTTPotion.Response{body: html, status_code: 200} = response
    html
  end

  defp parse_feed(html), do: Sipper.FeedParser.parse(html)
end
