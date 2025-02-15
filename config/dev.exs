import Config

config :logger, :console, level: :debug


config :bullhorn,
    producer:
      {BroadwayRabbitMQ.Producer,
      queue: "bullhorn",
      on_failure: :reject_and_requeue,
      connection: [
        username: "genesis76",
        password: "FjLrwdzqscJbW4u4WGmRHQH2txwKaprFDssKl12RpDWgj1zTIM3Wwbb9Pt45le2N",
        host: "b-df801284-a847-43cc-80f1-59b719624c35.mq.us-east-2.amazonaws.com",
        port: "5671",
        ssl_options: [verify: :verify_none]
      ]},
    phone_number: "776565521"
