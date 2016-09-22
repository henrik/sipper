defmodule Sipper.ParameterParser do
  # "strict" means anything not in this list will be ignored.
  @option_parser_opts [
    strict: [
      user: :string,
      pw: :string,
      start: :string,
      max: :integer,
      dir: :string,
      ignore: :string,
      oldest_first: :boolean,
    ]
  ]

  def parse(opts_from_args, config_file_path) do
    Dict.merge(
      parse_config_file(config_file_path),
      parse_args(opts_from_args)
    )
  end

  defp parse_args(opts_from_args) do
    opts_from_args
    |> parse_list
  end

  defp parse_config_file(path) do
    if File.exists?(path) do
      File.read!(path)
      |> String.rstrip
      |> OptionParser.split
      |> parse_list
    else
      []
    end
  end

  defp parse_list(list) do
    {options, _, _} =
      OptionParser.parse(list, @option_parser_opts)

    options
  end
end
