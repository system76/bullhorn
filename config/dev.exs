import Config

config :logger, :console, level: :debug

config :bullhorn,
  producer:
    {BroadwayRabbitMQ.Producer,
     queue: "bullhorn",
     connection: [
       username: "bullhorn",
       password: System.get_env("RMQ_PASSWORD", "system76"),
       host: System.get_env("RMQ_HOST", "localhost"),
       port: System.get_env("RMQ_PORT", "5672")
     ]}
