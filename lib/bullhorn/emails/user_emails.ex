defmodule Bullhorn.Emails.UserEmails do
  @moduledoc """
  All emails we send via Bamboo
  """
  import Bamboo.Email

  alias Bamboo.MailgunHelper

  def welcome(user) do
    user_variables = Map.take(user, [:email, :first_name])

    new_email()
    |> to(user.email)
    |> from("no-reply@system76.com")
    |> subject("Welcome to the System76 community!")
    |> MailgunHelper.template("welcome")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  def account_reset(user) do
    fields_for_email = ~w(email reset_key first_name last_name)a
    user_variables = Map.take(user, fields_for_email)

    new_email()
    |> to(user.email)
    |> from("no-reply@system76.com")
    |> subject("Recover your account")
    |> MailgunHelper.template("user_recovery")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end

  def password_reset_notification(%{email: email, first_name: first_name}) do
    new_email()
    |> to(email)
    |> from("no-reply@system76.com")
    |> subject("Your System76 password has been updated")
    |> MailgunHelper.template("password_was_reset")
    |> MailgunHelper.substitute_variables("first_name", first_name)
  end
end
