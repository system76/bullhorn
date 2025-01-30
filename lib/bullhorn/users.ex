defmodule Bullhorn.Users do
  @moduledoc """
  Handle the logic for User related notifications both to customers and employees
  """

  require Logger

  alias Bottle.Account.V1.{
    PasswordChanged,
    PasswordReset,
    TwoFactorRequested,
    TwoFactorRecoveryCodeUsed,
    UserCreated,
    Verification
  }

  alias Bullhorn.Emails.UserEmails
  alias Bullhorn.{Mailer, Twilio}

  def created(%UserCreated{user: user}) do
    user
    |> UserEmails.welcome()
    |> send_user_email()
  end

  def password_changed(%PasswordChanged{user: user}) do
    user
    |> UserEmails.password_changed()
    |> send_user_email()
  end

  def password_reset(%PasswordReset{user: user, reset_url: reset_url}) do
    user
    |> UserEmails.password_reset(reset_url)
    |> send_user_email()
  end

  def two_factor_requested(%TwoFactorRequested{token: token, user: user, method: :TWO_FACTOR_METHOD_SMS}) do
    Twilio.deliver_sms_two_factor_token(user, token)
  end

  def two_factor_requested(%TwoFactorRequested{token: token, user: user, method: :TWO_FACTOR_METHOD_VOICE}) do
    Twilio.deliver_voice_two_factor_token(user, token)
  end

  def two_factor_requested(%TwoFactorRequested{token: token, user: user, method: :TWO_FACTOR_METHOD_EMAIL}) do
    user
    |> UserEmails.deliver_email_two_factor_token(token)
    |> send_user_email()
  end

  def recovery_code_used(%TwoFactorRecoveryCodeUsed{codes_remaining: remaining, recovery_code: used_code, user: user}) do
    user
    |> UserEmails.recovery_code_used(used_code, remaining)
    |> send_user_email()
  end

  def verify_account(%Verification{user: user, verification_url: verification_url}) do
    user
    |> UserEmails.account_verification(verification_url)
    |> send_user_email()
  end

  defp send_user_email(email) do
    Mailer.send(email)
  end
end
