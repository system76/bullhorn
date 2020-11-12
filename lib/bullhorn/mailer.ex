defmodule Bullhorn.Mailer do
  use Bamboo.Mailer, otp_app: :bullhorn
  use Appsignal.Instrumentation.Decorators

  require Logger

  @decorate transaction(:email)
  def send(email) do
    Logger.debug("Sending email: #{email.subject}")
    deliver_now(email)
  rescue
    e in Bamboo.ApiError -> bamboo_error(e)
  end

  defp bamboo_error(%{message: message} = e) do
    if String.contains?(message, "Sandbox subdomains are for test purposes only") do
      :ignored
    else
      raise e
    end
  end
end
