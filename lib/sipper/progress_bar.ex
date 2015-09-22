defmodule Sipper.ProgressBar do
  # https://en.wikipedia.org/wiki/Block_Elements
  @bar "█"
  @blank "░"

  def print(acc, total) do
    format = [
      bar: @bar,
      blank: @blank,
      left: "", right: "",
      bar_color: IO.ANSI.magenta,
      blank_color: IO.ANSI.magenta,
      bytes: true,
    ]

    ProgressBar.render(acc, total, format)
  end

  def print_indeterminate do
    format = [
      bars: [
        @bar <> @blank <> @blank <> @blank,
        @blank <> @bar <> @blank <> @blank,
        @blank <> @blank <> @bar <> @blank,
        @blank <> @blank <> @blank <> @bar,
      ],
      done: @bar,
      bars_color: IO.ANSI.magenta,
      done_color: IO.ANSI.magenta,
      left: "", right: "",
    ]

    ProgressBar.render_indeterminate(format)
  end

  def terminate do
    ProgressBar.terminate
  end
end
