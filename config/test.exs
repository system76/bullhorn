use Mix.Config

config :bullhorn,
  producer: {Broadway.DummyProducer, []}
