defmodule RockeliveryWeb.OrdersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias Rockelivery.{Item, Order, User}
  alias RockeliveryWeb.OrdersView

  test "renders order.json" do
    user = build(:user)
    item = build(:item)
    order = build(:order, user: user, items: [item])

    response = render(OrdersView, "order.json", order: order)

    item_id = item.id
    user_id = user.id

    assert %Order{user: %User{id: ^user_id}, items: [%Item{id: ^item_id}]} = response
  end

  test "renders orders.json" do
    user = build(:user)
    item = build(:item)
    order = build(:order, user: user, items: [item])

    response = render(OrdersView, "orders.json", orders: [order, order])

    item_id = item.id
    user_id = user.id

    assert [
             %Order{user: %User{id: ^user_id}, items: [%Item{id: ^item_id}]},
             %Order{user: %User{id: ^user_id}, items: [%Item{id: ^item_id}]}
           ] = response
  end
end
