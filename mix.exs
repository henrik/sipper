defmodule Sipper.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sipper,
      version: "0.0.1",
      elixir: "~> 1.0",
      escript: [main_module: Sipper.CLI],
      default_task: "escript.build",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
    ]
  end

  def application do
    [applications: [
      :logger,
      :httpotion,
    ]]
  end

  defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
      {:floki, "~> 0.4.1"},
      {:progress_bar, ">= 0.0.5"},
    ]
  end
end
