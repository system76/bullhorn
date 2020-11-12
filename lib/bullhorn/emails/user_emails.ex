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

  def password_reset(%{email: email} = user, reset_key) do
    fields_for_email = [:email, :first_name, :last_name]

    user_variables =
      user
      |> Map.take(fields_for_email)
      |> Map.put(:reset_key, reset_key)

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

  defp full_name(%{first_name: first, last_name: last}), do: String.trim("#{first} #{last}")
end
