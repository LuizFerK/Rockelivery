defmodule Rockelivery.Orders.Get do
  alias Rockelivery.{Error, Order, Repo}

  def by_id(id) do
    case Repo.get(Order, id) do
      nil -> {:error, Error.build_order_not_found_error()}
      order -> {:ok, Repo.preload(order, :items)}
    end
  end
end
