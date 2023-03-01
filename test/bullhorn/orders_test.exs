defmodule Bullhorn.OrdersTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Bottle.Fulfillment.V1.Order
  alias Bottle.Fulfillment.V1.TribbleFailed
  alias Bullhorn.Orders

  describe "tribble_failed/1" do
    test "sends an internal email for TribbleFailed message types" do
      order = Order.new(id: 999)

      Orders.tribble_failed(TribbleFailed.new(order: order, type: :FAILURE_TYPE_ALREADY_SHIPPED))
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: order already shipped")

      Orders.tribble_failed(TribbleFailed.new(order: order, type: :FAILURE_TYPE_INVALID_ADDRESS))
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: invalid shipping address")

      Orders.tribble_failed(TribbleFailed.new(order: order, type: :NOT_YET_EXPLICITLY_HANDLED_ERROR))
      assert_email_delivered_with(subject: "Assembling Order #{order.id} failed: unexpected Tribble error")
    end
  end
end
