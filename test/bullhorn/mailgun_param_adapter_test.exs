defmodule Bullhorn.MailgunParamAdapterTest do
  use ExUnit.Case
  use Bamboo.Test

  import Bamboo.Email

  alias Bullhorn.MailgunParamAdapter
  alias Bamboo.MailgunHelper

  describe "mailgun_body/1" do
    test "builds from basic Bamboo.Email%{}" do
      request_body =
        new_email(
          to: [nil: "destination@example.com"],
          from: {nil, "source@example.com"},
          subject: "test subject",
          text_body: "Email body"
        )
        |> MailgunParamAdapter.mailgun_body()

      assert request_body == "from=source%40example.com&subject=test+subject&to=destination%40example.com"
    end

    test "builds with attachments" do
      request_body =
        new_email(
          to: [nil: "destination@example.com"],
          from: {nil, "source@example.com"},
          subject: "test subject",
          text_body: "Email body"
        )
        |> put_attachment(%Bamboo.Attachment{filename: "test file", data: "data"})
        |> MailgunParamAdapter.mailgun_body()

      assert request_body ==
               {:multipart,
                [
                  {"from", "source@example.com"},
                  {"subject", "test subject"},
                  {"to", "destination@example.com"},
                  {"", "data", {"form-data", [{"name", "\"attachment\""}, {"filename", "\"test file\""}]}, []}
                ]}
    end

    test "builds with headers" do
      request_body =
        new_email(
          to: [nil: "destination@example.com"],
          from: {nil, "source@example.com"},
          subject: "email with header vars",
          text_body: "Email body"
        )
        |> MailgunHelper.substitute_variables("first_name", "Name")
        |> MailgunParamAdapter.mailgun_body()

      assert request_body ==
               "from=source%40example.com&h%3AX-Mailgun-Variables=%7B%22first_name%22%3A%22Name%22%7D&subject=email+with+header+vars&to=destination%40example.com"
    end
  end
end
