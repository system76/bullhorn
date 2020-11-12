defmodule Bullhorn.OrdersTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Fulfillment.V1.Order
  alias Bottle.Notification.Order.V1.AssemblyFailure
  alias Bullhorn.Orders

  describe "handle_message/1" do
    setup do
      order = Order.new(id: 999)

      {:ok, order: order}
    end

    test "sends an internal email for AssemblyFailure message types", %{order: order} do
      Orders.handle_message(%AssemblyFailure{order: order, type: :FAILURE_TYPE_ALREADY_SHIPPED})
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: order already shipped")

      Orders.handle_message(%AssemblyFailure{order: order, type: :FAILURE_TYPE_INVALID_ADDRESS})
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: invalid shipping address")

      Orders.handle_message(%AssemblyFailure{order: order, type: :NOT_YET_EXPLICITLY_HANDLED_ERROR})
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: unexpected Tribble error")
    end
  end
end
