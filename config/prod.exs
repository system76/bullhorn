import Config

config :logger,
  backends: [LoggerJSON],
  level: :info

config :appsignal, :config, active: true

config :bullhorn, Bullhorn.Tracer, disabled?: false

config :bullhorn, Bullhorn.Mailer, adapter: Bullhorn.MailgunParamAdapter
