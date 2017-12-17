defmodule Example.Mixfile do
  use Mix.Project

  def project do
    [
      app: :hangman,
      version: "1.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Example, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end

