defmodule Rockelivery.Orders.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Order}
  alias Rockelivery.Orders.Get

  describe "by_id/1" do
    setup do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order_id, user_id: user_id, items: [item])

      {:ok, order_id: order_id}
    end

    test "when the order with the given id exists, returns the order", %{order_id: order_id} do
      response = Get.by_id(order_id)

      assert {:ok, %Order{id: ^order_id}} = response
    end

    test "when the order with the given id does not exists, returns an error" do
      response = Get.by_id("675d8596-9950-4059-a1cd-ed1a2ec3d18d")

      {:error, %Error{status: :not_found, result: error}} = response

      assert error == "Order not found"
    end
  end
end
