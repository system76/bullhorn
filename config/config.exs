use Mix.Config

config :bullhorn,
  producer:
    {BroadwayRabbitMQ.Producer,
     queue: "",
     config: [
       access_key_id: "",
       secret_access_key: "",
       region: "us-east-2"
     ]},
  phone_number: ""

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :user_id, :order_id, :trace_id, :span_id],
  level: :info

config :logger_json, :backend,
  formatter: LoggerJSON.Formatters.DatadogLogger,
  metadata: :all

config :appsignal, :config,
  active: false,
  name: "Bullhorn"

config :bullhorn, Bullhorn.Tracer,
  service: :bullhorn,
  adapter: SpandexDatadog.Adapter,
  disabled?: true

config :bullhorn, SpandexDatadog.ApiServer,
  http: HTTPoison,
  host: "127.0.0.1"

config :spandex, :decorators, tracer: Bullhorn.Tracer

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.LocalAdapter

config :ex_twilio,
  account_sid: "",
  auth_token: ""

import_config "#{Mix.env()}.exs"
