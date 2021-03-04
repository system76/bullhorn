import Config

bullhorn_config =
  "CONFIG"
  |> System.fetch_env!()
  |> Jason.decode!()

config :bullhorn,
  producer:
    {BroadwayRabbitMQ.Producer,
     queue: bullhorn_config["RABBITMQ_QUEUE_NAME"],
     connection: [
       username: bullhorn_config["RABBITMQ_USERNAME"],
       password: bullhorn_config["RABBITMQ_PASSWORD"],
       host: bullhorn_config["RABBITMQ_HOST"],
       port: bullhorn_config["RABBITMQ_PORT"]
     ]},
  phone_number: bullhorn_config["TWILIO_PHONE_NUMBER"]

config :appsignal, :config,
  push_api_key: bullhorn_config["APPSIGNAL_PUSH_KEY"],
  env: bullhorn_config["ENVIRONMENT"]

config :bullhorn, Bullhorn.Tracer, env: bullhorn_config["ENVIRONMENT"]

config :bullhorn, Bullhorn.Mailer,
  api_key: bullhorn_config["MAILGUN_API_KEY"],
  domain: bullhorn_config["MAILGUN_DOMAIN"]

config :ex_twilio,
  account_sid: bullhorn_config["TWILIO_ACCOUNT_SID"],
  auth_token: bullhorn_config["TWILIO_AUTH_TOKEN"]
