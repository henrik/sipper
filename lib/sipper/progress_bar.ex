defmodule Sipper.ProgressBar do
  # https://en.wikipedia.org/wiki/Block_Elements
  @bar "█"
  @blank "░"

  def render(acc, total) do
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

  def render_spinner(text, done, fun) do
    format = [
      # Stole these frames from WebTranslateIt.
      frames: ~w[⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏],
      interval: 100,
      spinner_color: IO.ANSI.magenta,
      text: text,
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " ", done],
    ]

    ProgressBar.render_spinner(format, fun)
  end
end
