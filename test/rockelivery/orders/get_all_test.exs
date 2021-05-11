defmodule Rockelivery.Orders.GetAllTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.Order
  alias Rockelivery.Orders.GetAll

  describe "call/1" do
    setup do
      order1_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      order2_id = "b925ffac-7a13-43e1-9a0a-64639b140722"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140723"

      insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order1_id, user_id: user_id, items: [item])
      insert(:order, id: order2_id, user_id: user_id, items: [item])

      {:ok, order1_id: order1_id, order2_id: order2_id}
    end

    test "should return all orders", %{order1_id: order1_id, order2_id: order2_id} do
      response = GetAll.call()

      assert {:ok, [%Order{id: ^order1_id}, %Order{id: ^order2_id}]} = response
    end
  end
end
