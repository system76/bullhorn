defmodule Bullhorn.Emails.UserEmails do
  @moduledoc """
  All emails we send via Bamboo for users
  """
  import Bamboo.Email

  alias Bamboo.MailgunHelper

  def welcome(%{email: email} = user) do
    user_variables = Map.take(user, [:email, :first_name])

    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("Welcome to the System76 community!")
    |> MailgunHelper.template("welcome")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  def password_reset(%{email: email} = user, reset_url) do
    fields_for_email = [:email, :first_name, :last_name]

    user_variables =
      user
      |> Map.take(fields_for_email)
      |> Map.put(:reset_url, reset_url)

    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("Recover your System76 account")
    |> MailgunHelper.template("user_recovery")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  def password_changed(%{email: email, first_name: first_name} = user) do
    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("Your System76 password has been updated")
    |> MailgunHelper.template("password_was_reset")
    |> MailgunHelper.substitute_variables("first_name", first_name)
  end

  def deliver_email_two_factor_token(%{email: email} = user, token) do
    spaced_out_token =
      token
      |> String.upcase()

    fields_for_email = [:email, :first_name, :last_name]

    user_variables =
      user
      |> Map.take(fields_for_email)
      |> Map.put(:two_factor_token, spaced_out_token)

    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("Your System76 login verification code")
    |> MailgunHelper.template("deliver_email_two_factor_token")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  def recovery_code_used(%{email: email, first_name: first_name} = user, used_code, codes_remaining) do
    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("A recovery code for your System76 account has been used")
    |> MailgunHelper.template("recovery_code_used")
    |> MailgunHelper.substitute_variables("first_name", first_name)
    |> MailgunHelper.substitute_variables("recovery_code", used_code)
    |> MailgunHelper.substitute_variables("codes_remaining", codes_remaining)
  end

  def account_verification(%{email: email} = user, verification_url) do
    fields_for_email = [:email, :first_name, :last_name]

    user_variables =
      user
      |> Map.take(fields_for_email)
      |> Map.put(:verify_url, verification_url)

    new_email()
    |> to({full_name(user), email})
    |> from("no-reply@system76.com")
    |> subject("Verify your System76 account")
    |> MailgunHelper.template("account_verification")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  defp full_name(%{first_name: first, last_name: last}), do: String.trim("#{first} #{last}")
end
