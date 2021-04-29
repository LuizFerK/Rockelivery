defmodule RockeliveryWeb.ItemsViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias Rockelivery.Item
  alias RockeliveryWeb.ItemsView

  test "renders item.json" do
    item = build(:item)

    response = render(ItemsView, "item.json", item: item)

    assert %Item{
             category: "food",
             description: "Pepperoni Pizza",
             photo: "/priv/photo/pepperoni_pizza.jpg"
           } = response
  end
end
