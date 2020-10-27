defmodule Bullhorn.Handlers.ErrorHandler do
  alias Bottle.Notification.V1.Error
  alias Bullhorn.Slack

  def handle_message(%Error{} = error) do
    channel =
      error
      |> error_blocks()
      |> Slack.post_message()
  end

  defp error_blocks(%Error{error: error, reason: reason, context: context} = error) do
    blocks = [
      Slack.section_block("A #{error} has been reported:\n\n #{reason}"),
      Slack.divider_block(),
      Slack.section_block("*Context:*"),
      Slack.field_blocks(context)
    ]
  end

  defp error_channel(%Error{error: "TribbleError"}), do: Map.get(slack_channels(), "#operations-software")
  defp error_channel(_), do: Map.get(slack_channels(), "#devops")

  defp slack_channels, do: Application.get_env(:bullhorn, :channels)
end
