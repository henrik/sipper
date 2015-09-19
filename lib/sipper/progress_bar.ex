defmodule Sipper.ProgressBar do
  # https://en.wikipedia.org/wiki/Block_Elements
  @bar "█"
  @blank "░"

  def print(acc, total) do
    format = [
      bar: @bar,
      blank: @blank,
      bar_color: IO.ANSI.magenta,
      blank_color: IO.ANSI.magenta,
      bytes: true,
    ]

    ProgressBar.render(acc, total, format)
  end
end
