import Config

config :bullhorn,
  producer: {Broadway.DummyProducer, []}

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.TestAdapter
#  adapter: Bullhorn.MailgunParamAdapter,
#  http: HTTPoisonMock,
#  api_key: "abc",
#  domain: "https://api.mailgun.net/test"

config :logger,
  level: System.get_env("LOG_LEVEL", "critical") |> String.to_existing_atom()
