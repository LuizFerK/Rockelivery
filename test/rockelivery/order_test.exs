defmodule Rockelivery.OrderTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.{Item, Order}

  describe "changeset/1" do
    setup do
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140721"

      insert(:user, id: user_id)
      item = insert(:item)

      {:ok, user_id: user_id, item: item}
    end

    test "when all params are valid, return a valid changeset", %{user_id: user_id, item: item} do
      params = build(:order_params, %{"user_id" => user_id, "items" => [item]})

      response = Order.changeset(params)

      assert %Changeset{valid?: true} = response
    end

    test "when there are invalid params, returns an invalid changeset" do
      params = build(:order_params, %{"comments" => 123, "items" => []})

      response = Order.changeset(params)

      assert %{comments: ["is invalid"]} = errors_on(response)
    end
  end

  describe "changeset/2" do
    setup do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user1_id = "b925ffac-7a13-43e1-9a0a-64639b140722"
      user2_id = "b925ffac-7a13-43e1-9a0a-64639b140723"
      item1_id = "b925ffac-7a13-43e1-9a0a-64639b140724"
      item2_id = "b925ffac-7a13-43e1-9a0a-64639b140725"

      insert(:user, id: user1_id)
      insert(:user, id: user2_id, cpf: "12345678901", email: "test@example.com")

      item1 = insert(:item, id: item1_id)
      item2 = insert(:item, id: item2_id)

      order = insert(:order, id: order_id, user_id: user1_id, items: [item1])

      {:ok, order: order, user2_id: user2_id, item2: item2}
    end

    test "when all params are valid, returns the updated changeset", %{
      order: order,
      user2_id: user2_id,
      item2: item2
    } do
      params = %{
        "user_id" => user2_id,
        "items" => [item2],
        "address" => "Random street, 12",
        "comments" => "Extra bacon",
        "payment_method" => "money"
      }

      response = Order.changeset(order, params)

      assert %Changeset{
               data: %Order{},
               changes: %{
                 address: "Random street, 12",
                 comments: "Extra bacon",
                 items: [%Changeset{data: %Item{}, valid?: true} | _],
                 payment_method: :money,
                 user_id: ^user2_id
               },
               valid?: true
             } = response
    end

    test "when there are invalid params, returns an invalid updated changeset", %{order: order} do
      params = %{
        "address" => 123,
        "comments" => 123,
        "payment_method" => "invalid_payment_method"
      }

      response = Order.changeset(order, params)

      assert %{
               address: ["is invalid"],
               comments: ["is invalid"],
               payment_method: ["is invalid"]
             } = errors_on(response)
    end
  end
end
