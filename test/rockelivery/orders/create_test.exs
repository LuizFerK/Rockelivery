defmodule Rockelivery.Orders.CreateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item, Order}
  alias Rockelivery.Orders.Create

  describe "call/1" do
    setup do
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      item_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      insert(:user, id: user_id)
      insert(:item, id: item_id)

      {:ok, user_id: user_id, item_id: item_id}
    end

    test "when all params are valid, returns an order", %{user_id: user_id, item_id: item_id} do
      params =
        build(:order_params, %{
          "user_id" => user_id,
          "items" => [%{"id" => item_id, "quantity" => 2}]
        })

      response = Create.call(params)

      assert {:ok, %Order{user_id: ^user_id, items: [%Item{id: ^item_id} | _]}} = response
    end

    test "when there are invalid params, returns an error" do
      params = build(:order_params, %{"invalid_params" => 123})

      response = Create.call(params)

      assert {:error, %Error{result: "Invalid ids", status: :bad_request}} = response
    end
  end
end
