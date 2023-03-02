defmodule Bullhorn.TemplatesTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Templates.V1.TemplatedEmail
  alias Bottle.Templates.V1.TypedAttachment
  alias Bullhorn.Email.Templates

  @moduletag capture_log: true

  describe "send_email/1" do
    test "valid send_email/1" do
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

      assert_email_delivered_with(subject: "test")
    end

    test "valid send_email/1 with attachment" do
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

      assert_email_delivered_with(subject: "test")
    end
  end
end
