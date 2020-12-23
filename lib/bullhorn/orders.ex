defmodule Bullhorn.Orders do
  @moduledoc """
  Handle the logic for Order related notifications both to customers and internally
  """

  alias Bottle.Notification.Order.V1.AssemblyFailure
  alias Bullhorn.Emails.OrderEmails
  alias Bullhorn.Mailer

  def handle_message(%{order: %{id: order_id}} = message) do
    Logger.metadata(order_id: order_id)

    message
    |> build_email()
    |> Mailer.send()
  end

  def build_email(%AssemblyFailure{order: order, type: failure_type}),
    do: OrderEmails.assembly_failure(order, failure_type)
end
