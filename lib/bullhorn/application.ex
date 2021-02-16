defmodule Bullhorn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = [
      {SpandexDatadog.ApiServer, [http: HTTPoison, host: "127.0.0.1"]},
      {Bullhorn.Broadway, []}
    ]

    Logger.info("Starting Bullhorn")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bullhorn.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
