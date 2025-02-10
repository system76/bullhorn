defmodule Bullhorn.MixProject do
  use Mix.Project

  def project do
    [
      app: :bullhorn,
      version: "0.1.0",
      elixir: "~> 1.18.2",
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
      {:appsignal, "~> 2.13.3"},
      {:amqp, "~> 4.0.0", override: true},
      {:ranch, "~> 2.1", override: true},
      {:bamboo, "~> 2.3.1"},
      {:bottle, github: "system76/bottle", ref: "465b429c7b341eb92dcfb7f210170a1e5265da41"},
      {:broadway_rabbitmq, "~> 0.8.2"},
      {:credo, "~> 1.7.11", only: [:dev, :test]},
      {:decorator, "~> 1.4"},
      {:ex_twilio, "~> 0.10"},
      {:hackney, "~> 1.20.1"},
      {:jason, "~> 1.4.4", override: true},
      {:logger_json, "~> 5.1.4"},
      {:pdf_generator, "~> 0.6.2"},
      {:plug, "~> 1.16.1"},
      {:saxy, "~> 1.6"},
      {:spandex, "~> 3.2"},
      {:spandex_datadog, "~> 1.4"},
      {:telemetry, "~> 1.0"},
      {:mox, "~> 1.2", only: :test}
    ]
  end
end
