defmodule Bullhorn.MailgunParamAdapterTest do
  use ExUnit.Case
  use Bamboo.Test

  import Bamboo.Email

  alias Bullhorn.MailgunParamAdapter

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
  end
end
