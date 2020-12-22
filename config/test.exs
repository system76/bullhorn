import Config

config :bullhorn,
  producer: {Broadway.DummyProducer, []}

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.TestAdapter
