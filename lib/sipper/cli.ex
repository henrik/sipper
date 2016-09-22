defmodule Sipper.CLI do
  @config_file System.user_home! |> Path.join(".sipper")

  def main(args) do
    args
    |> parse_args
    |> run
  end

  defp parse_args(args) do
    Sipper.ParameterParser.parse(args, @config_file)
  end

  defp run(options) do
    user   = Dict.fetch!(options, :user)
    pw     = Dict.fetch!(options, :pw)
    ignore = Dict.get(options, :ignore, "")

    config = %Sipper.Config{
      auth:         {user, pw},
      dir:          Dict.get(options, :dir, "./downloads") |> Path.expand,
      start:        Dict.get(options, :start, 1),
      max:          Dict.get(options, :max, :unlimited),
      ignore:       String.split(ignore, ",", trim: true),
      oldest_first: Dict.get(options, :oldest_first, false),
    }

    Sipper.Runner.run(config)
  end
end
