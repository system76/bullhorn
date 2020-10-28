defmodule Bullhorn.Emails.OrderEmails do
  @moduledoc """
  All emails we send via Bamboo
  """
  import Bamboo.Email

  alias Bamboo.MailgunHelper

  def order_error(order) do
    user_variables = Map.take(user, [:email, :first_name])

    new_email()
    |> to(user.email)
    |> from("no-reply@system76.com")
    |> subject("Welcome to the System76 community!")
    |> MailgunHelper.template("welcome")
    |> MailgunHelper.substitute_variables("user", user_variables)
  end
end
