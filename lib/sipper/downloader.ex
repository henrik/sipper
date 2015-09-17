defmodule Sipper.Downloader do
  @subdomain "elixirsips"
  @feed_url  "https://#{@subdomain}.dpdcart.com/feed"
  @login_url "https://#{@subdomain}.dpdcart.com/subscriber/login"

  def run(user, pw) do
    IO.puts "Retrieving feed…"

    # Retrieving the feed:
    %HTTPotion.Response{body: html, status_code: 200} = HTTPotion.get(@feed_url, basic_auth: {user, pw})
    IO.puts String.length(html)  # TODO: use it…

    # Logging in…
    post_body = URI.encode_query(username: user, password: pw)
    response = HTTPotion.post @login_url,
      body: post_body,
      headers: ["Content-Type": "application/x-www-form-urlencoded"]

    # … and getting a session cookie
    [_blah, raw_cookie] = response.headers |> Keyword.fetch!(:"Set-Cookie")
    cookie = raw_cookie |> String.split(";") |> hd

    # Downloading a file using that cookie
    small_markdown_file = "https://elixirsips.dpdcart.com/subscriber/download?file_id=58825"
    response = HTTPotion.get small_markdown_file, headers: ["Cookie": cookie]
    IO.puts response.body
  end
end
