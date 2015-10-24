defmodule Sipper.ProgressBar do
  @bar_format [
    bar: "█",
    blank: "░",
    left: "", right: "",
    bar_color: IO.ANSI.magenta,
    blank_color: IO.ANSI.magenta,
    bytes: true,
  ]

  @spinner_format [
    frames: :braille,
    spinner_color: IO.ANSI.magenta,
  ]

  def render(acc, total) do
    ProgressBar.render(acc, total, @bar_format)
  end

  def render_spinner(text, done, fun) do
    format = @spinner_format ++ [
      text: text,
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " ", done],
    ]
    ProgressBar.render_spinner(format, fun)
  end
end
