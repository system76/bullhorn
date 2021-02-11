use Mix.Config

config :bullhorn,
  producer:
    {BroadwaySQS.Producer,
     queue_url: "",
     config: [
       access_key_id: "",
       secret_access_key: "",
       region: "us-east-2"
     ]},
  phone_number: ""

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

config :appsignal, :config,
  active: false,
  name: "Bullhorn"

config :bullhorn, Bullhorn.Mailer, adapter: Bamboo.LocalAdapter

config :ex_twilio,
  account_sid: "",
  auth_token: ""

import_config "#{Mix.env()}.exs"
