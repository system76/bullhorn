defmodule Bullhorn.Email.Templates do
  @moduledoc """
  Passing along templated emails.
  """

  import Bamboo.Email

  alias Bamboo.MailgunHelper
  alias Bottle.Templates.V1.TemplatedEmail
  alias Bottle.Templates.V1.TypedAttachment
  alias Bullhorn.Mailer

  require Logger

  @spec send_email(TemplatedEmail.t()) :: {:ok, Bamboo.Email.t()} | {:error, String.t()}
  def send_email(
        %TemplatedEmail{
          template_name: name,
          form_variables: vars,
          email_from: from,
          email_to: to,
          subject: subject,
          attachments: source_attachments
        } = message
      ) do
    try do
      {:ok, vars_map} = Jason.decode(vars)

      email =
        new_email()
        |> to(to)
        |> from(from)
        |> subject(subject)
        |> MailgunHelper.template(name)
        |> MailgunHelper.substitute_variables(vars_map)

      source_attachments
      |> Enum.reduce(email, fn attachment, e ->
        put_attachment(e, convert_attachment(attachment))
      end)
      |> Mailer.send()
    rescue
      e ->
        error = "TemplatedEmail cannot be applied from message: #{inspect(message)} with error #{inspect(e)}"
        Logger.error(error)
        {:error, error}
    end
  end

  defp convert_attachment(%TypedAttachment{type: "html-pdf", source: source, file_name: file_name}) do
    Logger.debug("converting html source to pdf... #{inspect(source)}")
    binary_pdf = PdfGenerator.generate_binary!(source)
    Logger.debug("done.")
    %Bamboo.Attachment{filename: file_name, data: binary_pdf}
  end

  defp convert_attachment(%TypedAttachment{type: t}) do
    e = "Unexpected attachment type: #{inspect(t)}"
    Logger.error(e)
    raise e
  end

  defp convert_attachment(a) do
    e = "Unexpected attachment: #{inspect(a)}}"
    Logger.error(e)
    raise e
  end
end
