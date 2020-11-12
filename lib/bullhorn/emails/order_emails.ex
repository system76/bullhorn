defmodule Bullhorn.Emails.OrderEmails do
  @moduledoc """
  All emails we send via Bamboo
  """
  import Bamboo.Email

  alias Bamboo.MailgunHelper
  alias Bottle.Fulfillment.V1.Order

  def assembly_failure(%Order{id: order_id}, failure_type) do
    reason = human_readable_message(failure_type)

    new_email()
    |> to("errors@system76.com")
    |> from("no-reply@system76.com")
    |> subject("Assembling Order #{order_id} failed: #{reason}")
    |> MailgunHelper.template("assembly_failure")
    |> MailgunHelper.substitute_variables("order", %{id: order_id})
  end

  defp human_readable_message(:FAILURE_TYPE_INVALID_ADDRESS), do: "invalid shipping address"
  defp human_readable_message(:FAILURE_TYPE_ALREADY_SHIPPED), do: "order already shipped"
  defp human_readable_message(_), do: "unexpected Tribble error"
end
