use Mix.Config

config :appsignal, :config, active: true

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.MailgunAdapter
