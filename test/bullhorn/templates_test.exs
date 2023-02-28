defmodule Bullhorn.TemplatesTest do
  use ExUnit.Case
  use Bamboo.Test

  import Mox

  alias Bottle.Templates.V1.TemplatedEmail
  alias Bottle.Templates.V1.TypedAttachment
  alias Bullhorn.Email.Templates

  @moduletag capture_log: true

  describe "valid send_email/1" do
    expect(HTTPoisonMock, :post, fn _, _, _, _ -> {:ok, %{status_code: 200}} end)

    {:ok, json} = Jason.encode(%{a: "1", b: "2"})
    {:ok, _} =
      Templates.send_email(
        TemplatedEmail.new(
          template_name: "template1",
          form_variables: json,
          email_from: "test@example.com",
          email_to: "user@example.com",
          subject: "test"
        )
      )

  end

  describe "valid send_email/1 with attachment" do
    expect(HTTPoisonMock, :post, fn _, _, _, _ -> {:ok, %{status_code: 200}} end)

    {:ok, json} = Jason.encode(%{a: "1", b: "2"})
    {:ok, _} =
      Templates.send_email(
        TemplatedEmail.new(
          template_name: "template1",
          form_variables: json,
          email_from: "test@example.com",
          email_to: "user@example.com",
          subject: "test",
          attachments: [
            TypedAttachment.new(
              type: "html-pdf",
              source: "<html><body><p>test</p></body></html>",
              file_name: "test.pdf"
            )
          ]
        )
      )
  end

  describe "invalid send_email/1 is not sent" do
    expect(HTTPoisonMock, :post, 0, fn _, _, _, _ -> {:ok, %{status_code: 200}} end)

    {:error, _} =
      Templates.send_email(
        TemplatedEmail.new(
          template_name: "template1",
          form_variables: 123,
          email_from: "test@example.com",
          email_to: "user@example.com",
          subject: "failure expected"
        )
      )
  end
end
