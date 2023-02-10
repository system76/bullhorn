defmodule Bullhorn.TemplatesTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Templates.V1.TemplatedEmail
  alias Bottle.Templates.V1.TypedAttachment
  alias Bullhorn.Email.Templates

  @moduletag capture_log: true

  describe "valid send_email/1" do
    {:ok, _} =
      Templates.send_email(
        TemplatedEmail.new(
          template_name: "template1",
          form_variables: %{a: "1", b: "2"},
          email_from: "test@example.com",
          email_to: "user@example.com",
          subject: "test"
        )
      )

    assert_email_delivered_with(subject: "test")
  end

  describe "valid send_email/1 with attachment" do
    {:ok, _} =
      Templates.send_email(
        TemplatedEmail.new(
          template_name: "template1",
          form_variables: %{a: "1", b: "2"},
          email_from: "test@example.com",
          email_to: "user@example.com",
          subject: "test",
          attachments: [TypedAttachment.new(type: "html-pdf", source: "<html><body><p>test</p></body></html>", file_name: "test.pdf")]
        )
      )

    assert_email_delivered_with(subject: "test")
  end

  describe "invalid send_email/1" do
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

    refute_email_delivered_with(subject: "test fail")
  end
end
