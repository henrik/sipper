defmodule SipperParameterParserTest do
  # Not async, because we're doing stuff with the file system.
  use ExUnit.Case, async: false

  setup do
    temp_path = System.tmp_dir! |> Path.join("sipper_test_config")

    on_exit fn ->
      File.rm_rf!(temp_path)
    end

    {:ok, temp_path: temp_path}
  end

  test "parses only given arguments if there is no config file" do
    result = Sipper.ParameterParser.parse(["--user", "from_arg"], "no_such_config_file")

    assert result == [user: "from_arg"]
  end

  test "parses only config file if there are no given arguments", %{temp_path: config_file_path} do
    File.write!(config_file_path, "--pw from_file")

    result = Sipper.ParameterParser.parse([], config_file_path)

    assert result == [pw: "from_file"]
  end

  test "combines given arguments with those from a config file", %{temp_path: config_file_path} do
    File.write!(config_file_path, "--pw from_file")

    result = Sipper.ParameterParser.parse(["--user", "from_arg"], config_file_path)

    assert result == [user: "from_arg", pw: "from_file"]
  end
end
