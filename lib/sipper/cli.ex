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
    user = Dict.fetch!(options, :user)
    pw = Dict.fetch!(options, :pw)

    config = %Sipper.Config{
      auth: {user, pw},
      dir: Dict.get(options, :dir, "./downloads") |> Path.expand ,
      max: Dict.get(options, :max, :unlimited),
    }

    Sipper.Runner.run(config)
  end
end
