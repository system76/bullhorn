defmodule Bullhorn.Users do
  @moduledoc """
  Handle the logic for User related notifications both to customers and employees 
  """

  require Logger

  alias Bottle.Account.V1.{PasswordChanged, PasswordReset, UserCreated}
  alias Bullhorn.Emails.UserEmails
  alias Bullhorn.Mailer

  def password_changed(%PasswordChanged{user: user}) do
    user
    |> UserEmails.password_changed()
    |> send_user_email(user)
  end

  def password_reset(%PasswordReset{user: user, reset_key: reset_key}) do
    user
    |> UserEmails.password_reset(reset_key)
    |> send_user_email(user)
  end

  def created(%UserCreated{user: user}) do
    user
    |> UserEmails.welcome()
    |> send_user_email(user)
  end

  defp send_user_email(email, user) do
    Logger.metadata(recipient_id: user.id)
    Mailer.send(email)
  end
end
