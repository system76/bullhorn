defmodule Bullhorn.MixProject do
  use Mix.Project

  def project do
    [
      app: :bullhorn,
      version: "0.1.0",
      elixir: "~> 1.14.1",
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
      {:amqp, "~> 2.0", override: true},
      {:bamboo, "~> 1.6"},
      {:bottle, github: "system76/bottle", ref: "cd3e55c3317b100678bbf16027505e22403996c1"},
      {:broadway_rabbitmq, "~> 0.7.2"},
      {:credo, "~> 1.3", only: [:dev, :test]},
      {:decorator, "~> 1.2"},
      {:ex_twilio, "~> 0.8.2"},
      {:hackney, "~> 1.16"},
      {:jason, "~> 1.2", override: true},
      {:logger_json, github: "Nebo15/logger_json", ref: "8e4290a"},
      {:pdf_generator, "~> 0.6"},
      {:plug, "~> 1.1"},
      {:saxy, "~> 1.1"},
      {:spandex, "~> 3.0.3"},
      {:spandex_datadog, "~> 1.1"},
      {:telemetry, "~> 0.4"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
