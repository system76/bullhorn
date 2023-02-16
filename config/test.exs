import Config

config :bullhorn,
  producer: {Broadway.DummyProducer, []}

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.TestAdapter

config :logger,
       level: System.get_env("LOG_LEVEL", "critical") |> String.to_existing_atom()
