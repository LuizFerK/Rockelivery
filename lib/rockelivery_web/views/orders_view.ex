defmodule RockeliveryWeb.OrdersView do
  use RockeliveryWeb, :view

  alias Rockelivery.Order

  def render("order.json", %{order: %Order{} = order}), do: order

  def render("orders.json", %{orders: [%Order{} | _] = orders}), do: orders
end
