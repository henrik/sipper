defmodule Sipper.CLI do
  def main(args) do
    args |> parse_args |> run
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      strict: [
        user: :string,
        pw: :string,
      ],
      switches: [
        max: :integer,
      ],
    )

    options
  end

  defp run(user: user, pw: pw, max: max) do
    Sipper.Runner.run(user, pw, max)
  end

  defp run(user: user, pw: pw) do
    Sipper.Runner.run(user, pw, :unlimited)
  end
end
