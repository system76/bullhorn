use Mix.Config

config :appsignal, :config, active: true

config :bullhorn, Bullhorn.Tracer, disabled?: false

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.MailgunAdapter
