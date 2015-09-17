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
    %HTTPotion.Response{body: body, status_code: 200} = HTTPotion.get(@feed_url, basic_auth: {user, pw})
    IO.puts body
  end
end
