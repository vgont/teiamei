defmodule Teiamei.MixProject do
  use Mix.Project

  def project do
    [
      app: :teiamei,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Teiamei.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:websock, "~> 0.5"},
      {:websock_adapter, "~> 0.5.8"},
      {:poison, "~> 6.0"}
    ]
  end
end
