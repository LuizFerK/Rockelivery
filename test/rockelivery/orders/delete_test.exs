defmodule Rockelivery.Orders.DeleteTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, Order}
  alias Rockelivery.Orders.Delete

  describe "call/1" do
    setup do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order_id, user_id: user_id, items: [item])

      {:ok, order_id: order_id}
    end

    test "when a valid id is given, delete the order", %{order_id: order_id} do
      response = Delete.call(order_id)

      assert {:ok, %Order{id: ^order_id}} = response
    end

    test "when an invalid id is given, returns an error" do
      response = Delete.call("2baadea4-1d22-4d8c-9455-2ea5d692f932")

      assert {:error, %Error{result: "Order not found", status: :not_found}} = response
    end
  end
end
