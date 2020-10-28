import Config

bullhorn_config =
  "CONFIG"
  |> System.fetch_env!()
  |> Jason.decode!()

producer_config =
  "SQS_PRODUCER"
  |> System.fetch_env!()
  |> Jason.decode!()

config :bullhorn,
  producer:
    {BroadwaySQS.Producer,
     queue_url: producer_config["queue_url"],
     config: [
       access_key_id: producer_config["access_key_id"],
       secret_access_key: producer_config["secret_access_key"],
       region: producer_config["region"]
     ]}

config :appsignal, :config,
  push_api_key: bullhorn_config["APPSIGNAL_KEY"],
  env: bullhorn_config["APPSIGNAL_ENV"]

config :bullhorn, Bullhorn.Mailer,
  api_key: bullhorn_config["MAILGUN_API_KEY"],
  domain: bullhorn_config["MAILGUN_DOMAIN"]
