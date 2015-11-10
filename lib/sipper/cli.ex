defmodule Sipper.CLI do
  @config_file System.user_home! <> "/.sipper"

  def main(args) do
    parse_config_file ++ args
    |> parse_args
    |> run
  end

  defp parse_config_file() do
    args = []
    if File.exists?(@config_file) do
      args = File.read!(@config_file) |> String.rstrip |> OptionParser.split
    end
    args
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
        oldest_first: :boolean,
      ],
    )

    options
  end

  defp run(options) do

    user = Dict.fetch!(options, :user)
    pw = Dict.fetch!(options, :pw)

    config = %Sipper.Config{
      auth: {user, pw},
      dir: Dict.get(options, :dir, "./downloads") |> Path.expand,
      max: Dict.get(options, :max, :unlimited),
      oldest_first: Dict.get(options, :oldest_first, :false),
    }

    IO.inspect config

    Sipper.Runner.run(config)
  end
end
