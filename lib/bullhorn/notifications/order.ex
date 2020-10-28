defmodule Bullhorn.OrderNotifications do
  @moduledoc """
  Handle the logic for Order related notifications both to customers and internally
  """

  alias Bottle.Notification.Order.V1

  def handle_message(%{} = error) do
    channel =
      error
      |> error_blocks()
      |> Slack.post_message()
  end
end
