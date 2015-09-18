defmodule Sipper.ProgressBar do
  def print(acc, total) do
    percent = acc / total * 100 |> Float.round(2)
    percent_int = percent |> Float.round |> trunc

    bar = String.duplicate("=", percent_int)
    space = String.duplicate(" ", 100 - percent_int)
    IO.write [
      "\r",
      IO.ANSI.blue, "[",
      IO.ANSI.magenta, "#{bar}#{space}",
      IO.ANSI.blue, "]",
      IO.ANSI.reset, " #{percent} % (#{mb acc}/#{mb total})",
    ]
  end

  defp mb(bytes) do
    number = bytes / 1_048_576 |> Float.round(2)
    "#{number} MB"
  end
end
