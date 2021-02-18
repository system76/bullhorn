defmodule Bullhorn.Orders do
  @moduledoc """
  Handle the logic for Order related notifications both to customers and internally
  """

  alias Bottle.Fulfillment.V1.TribbleFailed
  alias Bullhorn.Emails.OrderEmails
  alias Bullhorn.Mailer

  def tribble_failed(%TribbleFailed{order: order, type: failure_type}) do
    order
    |> OrderEmails.assembly_failure(failure_type)
    |> Mailer.send()
  end
end
