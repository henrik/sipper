defmodule Sipper.ProgressBar do
  # https://en.wikipedia.org/wiki/Block_Elements
  @bar "█"
  @blank "░"
  @format [
    bar: @bar,
    blank: @blank,
    left: "", right: "",
    bar_color: IO.ANSI.magenta,
    blank_color: IO.ANSI.magenta,
    bytes: true
  ]
  @format_spinner [
    frames: :braille,
    spinner_color: IO.ANSI.magenta
  ]

  def render(acc, total) do
    ProgressBar.render(acc, total, @format)
  end

  def render_spinner(text, done, fun) do
    format = format_spinner(text, done)
    ProgressBar.render_spinner(format, fun)
  end

  defp format_spinner(text, done) do
    @format_spinner ++ [text: text] ++ [done: [IO.ANSI.green, "✓", IO.ANSI.reset, " ", done]]
  end
end
