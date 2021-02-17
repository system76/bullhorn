import Config

bullhorn_config =
  "CONFIG"
  |> System.fetch_env!()
  |> Jason.decode!()

config :bullhorn,
  producer:
    {BroadwaySQS.Producer,
     queue_url: bullhorn_config["SQS_QUEUE_URL"],
     config: [
       access_key_id: bullhorn_config["ACCESS_KEY_ID"],
       secret_access_key: bullhorn_config["SECRET_ACCESS_KEY"],
       region: bullhorn_config["SQS_QUEUE_REGION"]
     ]},
  phone_number: bullhorn_config["TWILIO_PHONE_NUMBER"]

config :appsignal, :config,
  push_api_key: bullhorn_config["APPSIGNAL_PUSH_KEY"],
  env: bullhorn_config["APPSIGNAL_ENVIRONMENT"]

config :bullhorn, Bullhorn.Tracer, env: bullhorn_config["DATADOG_ENVIRONMENT"]

config :bullhorn, Bullhorn.Mailer,
  api_key: bullhorn_config["MAILGUN_API_KEY"],
  domain: bullhorn_config["MAILGUN_DOMAIN"]

config :ex_twilio,
  account_sid: bullhorn_config["TWILIO_ACCOUNT_SID"],
  auth_token: bullhorn_config["TWILIO_AUTH_TOKEN"]
