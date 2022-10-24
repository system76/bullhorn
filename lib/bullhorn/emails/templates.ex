defmodule Bullhorn.Email.Templates do
  @moduledoc """
  Passing along templated emails.
  """

  import Bamboo.Email

  alias Bamboo.MailgunHelper
  alias Bottle.Templates.V1.TemplatedEmail
  alias Bullhorn.Mailer

  require Logger

  @spec send_email(TemplatedEmail.t()) :: {:ok, Bamboo.Email.t()} | {:error, String.t()}
  def send_email(
        %TemplatedEmail{
          template_name: name,
          form_variables: vars,
          email_from: from,
          email_to: to,
          subject: subject
        } = message
      ) do
    try do
      new_email()
      |> to(to)
      |> from(from)
      |> subject(subject)
      |> MailgunHelper.template(name)
      |> MailgunHelper.substitute_variables(vars)
      |> Mailer.send()
    rescue
      e ->
        error = "TemplatedEmail cannot be applied from message: #{inspect(message)} with error #{inspect(e)}"
        Logger.error(error)
        {:error, error}
    end
  end
end
