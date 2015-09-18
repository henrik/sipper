defmodule Sipper.ProgressBar do
  # https://en.wikipedia.org/wiki/Block_Elements
  @bar "█"
  @blank "░"

  def print(acc, total) do
    percent = acc / total * 100 |> Float.round |> trunc

    bar = String.duplicate(@bar, percent)
    space = String.duplicate(@blank, 100 - percent)
    IO.write [
      "\r",
      IO.ANSI.magenta, "#{bar}#{space}",
      IO.ANSI.reset, " #{format_percent percent} % (#{mb acc}/#{mb total})",
    ]
  end

  defp format_percent(number) do
    number |> Integer.to_string |> String.rjust(3)
  end

  defp mb(bytes) do
    number = bytes / 1_048_576 |> Float.round(2)
    "#{number} MB"
  end
end
