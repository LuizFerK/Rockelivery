defmodule Rockelivery.Orders.UpdateTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, Item, Order}
  alias Rockelivery.Orders.Update

  describe "call/1" do
    setup do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user1_id = "b925ffac-7a13-43e1-9a0a-64639b140722"
      user2_id = "b925ffac-7a13-43e1-9a0a-64639b140723"
      item1_id = "b925ffac-7a13-43e1-9a0a-64639b140724"
      item2_id = "b925ffac-7a13-43e1-9a0a-64639b140725"

      insert(:user, id: user1_id)
      insert(:user, id: user2_id, cpf: "12345678901", email: "test@example.com")

      item1 = insert(:item, id: item1_id)
      insert(:item, id: item2_id)

      insert(:order, id: order_id, user_id: user1_id, items: [item1])

      {:ok, order_id: order_id, user2_id: user2_id, item2_id: item2_id}
    end

    test "when all params are valid, updates the order", %{
      order_id: order_id,
      user2_id: user2_id,
      item2_id: item2_id
    } do
      params =
        build(:order_params, %{
          "id" => order_id,
          "user_id" => user2_id,
          "items" => [%{"id" => item2_id, "quantity" => 1}],
          "comments" => "Extra bacon"
        })

      response = Update.call(params)

      assert {:ok, %Order{id: ^order_id, user_id: ^user2_id, items: [%Item{id: ^item2_id} | _]}} =
               response
    end

    test "even without items, if all params are valid, should update the order", %{
      order_id: order_id,
      user2_id: user2_id
    } do
      params =
        build(:order_params, %{
          "id" => order_id,
          "user_id" => user2_id,
          "items" => nil,
          "comments" => "Extra bacon"
        })

      response = Update.call(params)

      assert {:ok, %Order{id: ^order_id, user_id: ^user2_id}} = response
    end

    test "when an invalid id is given, returns an error", %{user2_id: user2_id} do
      params =
        build(:order_params, %{
          "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932",
          "user_id" => user2_id
        })

      response = Update.call(params)

      assert {:error, %Error{result: "Order not found", status: :not_found}} = response
    end

    test "when the user does not exists, returns an error", %{order_id: order_id} do
      params =
        build(:user_params, %{
          "id" => order_id,
          "user_id" => "2baadea4-1d22-4d8c-9455-2ea5d692f939"
        })

      response = Update.call(params)

      assert {:error, %Rockelivery.Error{result: "User not found", status: :not_found}} = response
    end
  end
end
