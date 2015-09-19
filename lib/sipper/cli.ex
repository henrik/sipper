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
        dir: :string,
      ],
    )

    options
  end

  defp run(options) do
    Sipper.Runner.run(
      Dict.fetch!(options, :user),
      Dict.fetch!(options, :pw),
      Dict.get(options, :max, :unlimited),
      Dict.get(options, :dir, "./downloads")
    )
  end
end
