defmodule Rockelivery.Orders.Delete do
  import Ecto.Query

  alias Rockelivery.{Error, Order, Repo}

  def call(id) do
    case Repo.get(Order, id) do
      nil -> {:error, Error.build_order_not_found_error()}
      order -> delete_order(order)
    end
  end

  defp delete_order(order) do
    query =
      from r in "orders_items",
        where: r.order_id == type(^order.id, Ecto.UUID),
        select: [r.order_id, r.item_id]

    Repo.delete_all(query)
    Repo.delete(order)
  end
end
