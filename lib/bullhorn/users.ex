defmodule Bullhorn.Users do
  @moduledoc """
  Handle the logic for User related notifications both to customers and employees 
  """

  require Logger

  alias Bottle.Notification.User.V1.{Created, PasswordChanged, PasswordReset}
  alias Bullhorn.Emails.UserEmails
  alias Bullhorn.Mailer

  def handle_message(%{user: %{id: user_id}} = message) do
    Logger.metadata(recipient_id: user_id)

    message
    |> build_email()
    |> Mailer.send()
  end

  defp build_email(%PasswordChanged{user: user}),
    do: UserEmails.password_changed(user)

  defp build_email(%PasswordReset{user: user, reset_key: reset_key}),
    do: UserEmails.password_reset(user, reset_key)

  defp build_email(%Created{user: user}),
    do: UserEmails.welcome(user)
end
