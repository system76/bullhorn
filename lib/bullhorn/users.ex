defmodule Bullhorn.Users do
  @moduledoc """
  Handle the logic for User related notifications both to customers and employees
  """

  require Logger

  alias Bottle.Account.V1.{
    NotificationMethodRequest,
    PasswordChanged,
    PasswordReset,
    Stub,
    TwoFactorRequested,
    UserCreated
  }

  alias Bullhorn.Emails.UserEmails
  alias Bullhorn.{Mailer, Twilio}

  def created(%UserCreated{user: user}) do
    user
    |> UserEmails.welcome()
    |> send_user_email(user)
  end

  def password_changed(%PasswordChanged{user: user}) do
    user
    |> UserEmails.password_changed()
    |> send_user_email(user)
  end

  def password_reset(%PasswordReset{user: user, reset_url: reset_url}) do
    user
    |> UserEmails.password_reset(reset_url)
    |> send_user_email(user)
  end

  def two_factor_requested(%TwoFactorRequested{token: token, user: user}) do
    with {:error, map, _status_code} <- deliver_two_factor_token(user, token) do
      {:error, inspect(map)}
    end
  end

  defp deliver_two_factor_token(user, token) do
    case user_notification_method(user, "two_factor") do
      {:NOTIFICATION_METHOD_SMS, user} ->
        Twilio.deliver_sms_two_factor_token(user, token)

      {:NOTIFICATION_METHOD_VOICE, user} ->
        Twilio.deliver_voice_two_factor_token(user, token)

      _ ->
        :ignored
    end
  end

  defp account_service_url, do: Application.get_env(:bullhorn, :account_service_url)

  defp send_user_email(email, user) do
    Logger.metadata(recipient_id: user.id)
    Mailer.send(email, response: true)
  end

  defp user_notification_method(user, event_type) do
    request =
      NotificationMethodRequest.new(event_type: event_type, request_id: Bottle.RequestId.write(:rpc), user: user)

    with {:ok, channel} <- GRPC.Stub.connect(account_service_url(), interceptors: [GRPC.Logger.Client]),
         {:ok, reply} <- Stub.notification_method(channel, request) do
      {reply.notification_method, reply.user}
    end
  end
end
