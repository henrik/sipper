defmodule SipperFileNameCleanerTest do
  use ExUnit.Case

  test "clean" do
    assert Sipper.FileNameCleaner.clean("Foo: Bar") == "Foo- Bar"
  end
end
