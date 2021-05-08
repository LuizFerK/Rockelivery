defmodule RockeliveryWeb.ItemsView do
  use RockeliveryWeb, :view

  alias Rockelivery.Item

  def render("item.json", %{item: %Item{} = item}), do: item

  def render("items.json", %{items: [%Item{} | _] = items}), do: items
end
