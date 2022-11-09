import Config

config :logger, :console,
  level: :debug

config :bullhorn,
       producer:
         {BroadwayRabbitMQ.Producer,
         queue: "bullhorn",
         on_failure: :reject_and_requeue,
         connection: [
           username: "bullhorn",
           password: System.get_env("RMQ_PASSWORD"),
           host: System.get_env("RMQ_HOST", "localhost"),
           port: System.get_env("RMQ_PORT", "5672")
         ]}
