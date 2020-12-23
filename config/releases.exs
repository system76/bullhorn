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
     ]}

config :appsignal, :config,
  push_api_key: bullhorn_config["APPSIGNAL_PUSH_KEY"],
  env: bullhorn_config["APPSIGNAL_ENV"]

config :bullhorn, Bullhorn.Mailer,
  api_key: bullhorn_config["MAILGUN_API_KEY"],
  domain: bullhorn_config["MAILGUN_DOMAIN"]
