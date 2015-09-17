defmodule Sipper do
  @feed_url "https://elixirsips.dpdcart.com/feed"

  def main(args) do
    args |> parse_args |> run
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [user: :string, pw: :string]
    )
    options
  end

  defp run(user: user, pw: pw) do
    IO.puts "Retrieving feed…"
    %HTTPotion.Response{body: html, status_code: 200} = HTTPotion.get(@feed_url, basic_auth: {user, pw})
    IO.puts String.length(html)  # TODO: use it…

    # Figure out how to download files:

    body = "username=#{user}&password=#{pw}"  # TODO: escape values
    response = HTTPotion.post "http://elixirsips.dpdcart.com/subscriber/login", body: body, headers: ["Content-Type": "application/x-www-form-urlencoded"]
    IO.inspect response

    [_blah, raw_cookie] = response.headers |> Keyword.fetch!(:"Set-Cookie")
    cookie = raw_cookie |> String.split(";") |> hd

    IO.inspect cookie: cookie

    small_markdown_file = "https://elixirsips.dpdcart.com/subscriber/download?file_id=58825"
    response = HTTPotion.get small_markdown_file, headers: ["Cookie": cookie]
    IO.puts response.body
  end
end
