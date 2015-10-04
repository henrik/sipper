defmodule Sipper.FileDownloader do
  # Vertical alignment.
  @exists_label "[EXISTS]"
  @get_label    "[GET]   "
  @rename_label "[RENAME]"

  def run(episodes, config) do
    episodes |> Enum.each(&download_episode(&1, config))
    IO.puts "All done!"
  end

  defp download_episode({title, files}, config) do
    files |> Enum.each(&download_file(title, &1, config))
  end

  defp download_file(title, file, config) do
    File.mkdir_p!(config.dir)

    rename_any_existing_file_to_new_clean_name(config.dir, title)

    dir = "#{config.dir}/#{clean_file_name title}"
    File.mkdir_p!(dir)

    rename_any_existing_file_to_new_clean_name(dir, file.name)
    path = "#{dir}/#{clean_file_name file.name}"

    if File.exists?(path) do
      IO.puts [IO.ANSI.blue, @exists_label, IO.ANSI.reset, " ", path]
    else
      IO.puts [IO.ANSI.magenta, @get_label, IO.ANSI.reset, " ", path]
      Sipper.DpdCartClient.get_file(file, config.auth, callback: &download_file_callback(&1, path))
    end
  end

  defp download_file_callback({:file_progress, acc, total}, _path) do
    Sipper.ProgressBar.render(acc, total)
  end

  defp download_file_callback({:file_done, data}, path) do
    File.write!(path, data)
  end

  defp clean_file_name(name) do
    Sipper.FileNameCleaner.clean(name)
  end

  # No need re-downloading stuff just because we changed how we clean up filenames.
  def rename_any_existing_file_to_new_clean_name(dir, file) do
    Sipper.FileNameCleaner.migrate_unclean dir, file, fn (old_file, new_file) ->
      IO.puts [IO.ANSI.yellow, @rename_label, IO.ANSI.reset, " ", ~s(Renaming "#{old_file}" -> "#{new_file}")]
    end
  end
end
