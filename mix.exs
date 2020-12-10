defmodule Bullhorn.MixProject do
  use Mix.Project

  def project do
    [
      app: :bullhorn,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        bullhorn: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bullhorn.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:appsignal, "~> 1.0"},
      {:bamboo, "~> 1.6"},
      {:plug, "~> 1.1"},
      {:bottle, github: "system76/bottle", ref: "90fccf4"},
      {:broadway_sqs, "~> 0.6.0"},
      {:saxy, "~> 1.1"},
      {:hackney, "~> 1.16"},
      {:jason, "~> 1.2", override: true},
      {:credo, "~> 1.3", only: [:dev, :test]}
    ]
  end
end
