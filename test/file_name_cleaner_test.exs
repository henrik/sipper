defmodule SipperFileNameCleanerTest do
  # Not async, because we're doing stuff with the file system.
  use ExUnit.Case, async: false

  setup do
    dir = System.tmp_dir! <> "/sipper_file_name_cleaner_test"
    File.mkdir!(dir)

    on_exit fn ->
      File.rm_rf!(dir)
    end

    {:ok, dir: dir}
  end

  test "clean" do
    assert Sipper.FileNameCleaner.clean("Foo: Bar") == "Foo- Bar"
  end

  test "migrate unclean: renames an existing directory to be clean", %{dir: dir} do
    File.mkdir("#{dir}/Foo: Bar")
    File.touch!("#{dir}/Foo: Bar/contents.txt")

    assert File.exists?("#{dir}/Foo: Bar")
    assert File.exists?("#{dir}/Foo: Bar/contents.txt")

    cb = fn (_old, _new) -> end
    Sipper.FileNameCleaner.migrate_unclean(dir, "Foo: Bar", cb)

    assert File.exists?("#{dir}/Foo- Bar")
    assert File.exists?("#{dir}/Foo- Bar/contents.txt")
    refute File.exists?("#{dir}/Foo: Bar")
  end

  test "migrate unclean: renames an existing file to be clean", %{dir: dir} do
    File.touch!("#{dir}/Foo: Bar.txt")

    assert File.exists?("#{dir}/Foo: Bar.txt")

    cb = fn (_old, _new) -> end
    Sipper.FileNameCleaner.migrate_unclean(dir, "Foo: Bar.txt", cb)

    assert File.exists?("#{dir}/Foo- Bar.txt")
    refute File.exists?("#{dir}/Foo: Bar.txt")
  end

  test "migrate unclean: leaves an already-clean file alone", %{dir: dir} do
    File.touch!("#{dir}/Already clean.txt")

    assert File.exists?("#{dir}/Already clean.txt")

    cb = fn (_old, _new) -> end
    Sipper.FileNameCleaner.migrate_unclean(dir, "Already clean.txt", cb)

    assert File.exists?("#{dir}/Already clean.txt")
  end

  test "migrate unclean: calls back with the old and new file names", %{dir: dir} do
    File.touch!("#{dir}/Foo: Bar.txt")

    cb = fn (old, new) ->
      send self, {:called_back, old, new}
    end

    Sipper.FileNameCleaner.migrate_unclean(dir, "Foo: Bar.txt", cb)

    assert_received {:called_back, "Foo: Bar.txt", "Foo- Bar.txt"}
  end
end
