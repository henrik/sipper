defmodule Sipper.CLI do
  def main(args) do
    args |> parse_args |> run
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [
      user: :string,
      pw: :string,
    ])

    options
  end

  defp run(user: user, pw: pw) do
    Sipper.Downloader.run(user, pw)
  end
end
