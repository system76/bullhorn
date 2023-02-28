defmodule Bullhorn.MailgunParamAdapter do
  @moduledoc """
  Based on Bamboo.MailgunAdapter, but with more flexibility in adding parameters (i.e. `t:variables`).
  Everything in `private` for the given %Bamboo.Email{} will be passed along as parameters in the Mailgun request.
  """

  @service_name "Mailgun"
  @default_base_uri "https://api.mailgun.net/v3"
  @behaviour Bamboo.Adapter

  alias Bamboo.{Email, Attachment}

  import Bamboo.ApiError

  def supports_attachments?, do: true

  def deliver(%Email{} = email, config) do
    request_body = mailgun_body(email)
    uri = mailgun_uri(config)
    headers = headers(email, config)

    post_mailgun(config, request_body, uri, headers)
  end

  def post_mailgun(config, body, uri, headers) do
    case config.http.post(uri, body, headers, []) do
      {:ok, %{status_code: status} = response} when status > 299 ->
        raise_api_error(@service_name, response, decode_body(body))

      {:ok, response} ->
        response

      {:error, error} ->
        raise_api_error(inspect(error))
    end
  end

  def mailgun_body(%Email{from: from, to: to, subject: subject} = email) do
    %{
      from: prepare_recipient(from),
      to: prepare_recipients(to),
      subject: subject
    }
    |> put_attachments(email)
    |> add_params(email)
    |> encode_body()
  end

  defp add_params(%{} = body, %Email{private: private} = _email), do: Map.merge(body, private)

  defp put_attachments(body, %Email{attachments: []}), do: body

  defp put_attachments(body, %Email{attachments: attachments}) do
    attachment_data = Enum.map(attachments, &prepare_file(&1))
    Map.put(body, :attachments, attachment_data)
  end

  def handle_config(config) do
    config
    |> Map.put(:api_key, get_config_env(config, :api_key))
    |> Map.put(:domain, get_config_env(config, :domain))
    |> Map.put_new(:base_uri, Application.get_env(:bullhorn, :mailgun_base_uri, @default_base_uri))
  end

  defp get_config_env(config, key) do
    with nil <- config[key],
         nil <- Application.get_env(:bullhorn, key) do
      raise "missing config variable: #{inspect(key)}"
    else
      val -> val
    end
  end

  # Borrowed from Bamboo.MailgunAdapter:

  def mailgun_uri(config), do: config.base_uri <> "/" <> config.domain <> "/messages"

  def headers(%Email{} = email, config) do
    [{"Content-Type", content_type(email)}, {"Authorization", "Basic #{auth_token(config)}"}]
  end

  defp auth_token(config), do: Base.encode64("api:" <> config.api_key)

  defp content_type(%{attachments: []}), do: "application/x-www-form-urlencoded"

  defp content_type(%{}), do: "multipart/form-data"

  defp encode_body(%{attachments: attachments} = body) do
    {
      :multipart,
      body
      |> Map.drop([:attachments])
      |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)
      |> Kernel.++(attachments)
    }
  end

  defp encode_body(body_without_attachments) do
    Plug.Conn.Query.encode(body_without_attachments)
  end

  defp decode_body({:multipart, _} = multipart_body), do: multipart_body

  defp decode_body(body_without_attachments) when is_binary(body_without_attachments),
    do: Plug.Conn.Query.decode(body_without_attachments)

  defp prepare_file(%Attachment{} = attachment) do
    {
      "",
      attachment.data,
      {"form-data", [{"name", ~s/"attachment"/}, {"filename", ~s/"#{attachment.filename}"/}]},
      []
    }
  end

  defp prepare_recipients(recipients) do
    recipients
    |> Enum.map(&prepare_recipient(&1))
    |> Enum.join(",")
  end

  defp prepare_recipient({nil, address}), do: address
  defp prepare_recipient({"", address}), do: address
  defp prepare_recipient({name, address}), do: "#{name} <#{address}>"
end
