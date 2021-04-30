defmodule RockeliveryWeb.OrdersView do
  use RockeliveryWeb, :view

  alias Rockelivery.Order

  def render("order.json", %{order: %Order{} = order}), do: order
end
