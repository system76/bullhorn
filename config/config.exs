use Mix.Config

config :bullhorn,
  producer:
    {BroadwaySQS.Producer,
     queue_url: "",
     config: [
       access_key_id: "",
       secret_access_key: "",
       region: "us-east-2"
     ]}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

config :appsignal, :config,
  active: false,
  name: "Bullhorn"

config :bullhorn, Bullorn.Mailer, adapter: Bamboo.LocalAdapter

config :bullhorn,
  message_handlers: [
    {Bullhorn.Orders,
     [
       Bottle.Notification.Order.V1.AssemblyFailure
     ]},
    {
      Bullhorn.Users,
      [
        Bottle.Notification.User.V1.PasswordChanged,
        Bottle.Notification.User.V1.PasswordReset,
        Bottle.Notification.User.V1.Welcome
      ]
    }
  ]

import_config "#{Mix.env()}.exs"
