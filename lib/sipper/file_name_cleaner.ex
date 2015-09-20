defmodule Sipper.FileNameCleaner do
  def clean(name) do
    name
    |> String.replace(":", "-")  # Breaks on Windows, shown as "/" on OS X.
  end

  def migrate_unclean(dir, file, cb) do
    files_in_dir = File.ls!(dir)
    cleaned_files_in_dir = Enum.into(files_in_dir, %{}, &{clean(&1), &1})

    cleaned_file = clean(file)
    existing_version_of_current_file = Dict.get(cleaned_files_in_dir, cleaned_file)

    if existing_version_of_current_file && existing_version_of_current_file != cleaned_file do
      cb.(existing_version_of_current_file, cleaned_file)
      mv!(dir, existing_version_of_current_file, cleaned_file)
    end
  end

  defp mv!(dir, old_file, new_file) do
    old_path = "#{dir}/#{old_file}"
    new_path = "#{dir}/#{new_file}"

    :ok = :file.rename(old_path, new_path)
  end
end
