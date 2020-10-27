defmodule Bullhorn.Slack do
  def post_messsage(blocks, channel) do
    body =
      Jason.encode!(%{
        channel: channel,
        blocks: blocks
      })

    HTTPoison.post("https://slack.com/api/chat.postMessage", body, [
      {"Authorization", "Bearer #{slack_api_token()}"},
      {"Content-Type", "application/json"}
    ])
  end

  def divider_block, do: %{type: "divider"}

  def field_blocks(fields) do
    %{
      type: "fields",
      fields: Enum.map(fields, fn {k, v} -> %{type: "mrkdwn", text: "*#{k}*\n#{v}"} end)
    }
  end

  def section_block(text) do
    %{
      type: "section",
      text: %{
        type: "mrkdwn",
        text: text
      }
    }
  end

  defp slack_api_token, do: Application.get_env(:samwise, :slack_api_token)
end
