defmodule Sipper.FileDownloader do
  # Vertical alignment.
  @exists_label "[EXISTS]"
  @get_label    "[GET]   "

  def run(episodes, config) do
    episodes |> Enum.each(&download_episode(&1, config))
    IO.puts "All done!"
  end

  defp download_episode({title, files}, config) do
    files |> Enum.each(&download_file(title, &1, config))
  end

  defp download_file(title, file, config) do
    dir = "#{config.dir}/#{title |> String.replace(":", " ")}"
    File.mkdir_p!(dir)

    path = "#{dir}/#{file.name}"

    if File.exists?(path) do
      IO.puts [IO.ANSI.blue, @exists_label, IO.ANSI.reset, " ", path]
    else
      IO.puts [IO.ANSI.magenta, @get_label, IO.ANSI.reset, " ", path]
      Sipper.DpdCartClient.get_file(file, config.auth, callback: &download_file_callback(&1, path))
    end
  end

  defp download_file_callback({:file_progress, acc, total}, _path) do
    Sipper.ProgressBar.print(acc, total)
  end

  defp download_file_callback({:file_done, data}, path) do
    File.write!(path, data)
  end
end
