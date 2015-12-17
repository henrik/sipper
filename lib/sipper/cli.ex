defmodule Sipper.CLI do
  @config_file System.user_home! <> "/.sipper"

  def main([]) do
    if File.exists?(@config_file) do
      args = File.read!(@config_file) |> String.rstrip |> OptionParser.split
      main(args)
    else
      IO.puts :stderr, "Please provide parameters!"
    end
  end

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
        ignore: :string,
        asc: :boolean
      ],
    )

    options
  end

  defp run(options) do
    user   = Dict.fetch!(options, :user)
    pw     = Dict.fetch!(options, :pw)
    ignore = Dict.get(options, :ignore, "")

    config = %Sipper.Config{
      auth:      {user, pw},
      dir:       Dict.get(options, :dir, "./downloads") |> Path.expand,
      max:       Dict.get(options, :max, :unlimited),
      ignore:    String.split(ignore, ",", trim: true),
      ascending: Dict.get(options, :asc, false),
    }

    Sipper.Runner.run(config)
  end
end
