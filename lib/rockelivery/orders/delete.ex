defmodule Rockelivery.Orders.Delete do
  alias Rockelivery.{Error, Order, Repo}

  def call(id) do
    case Repo.get(Order, id) do
      nil -> {:error, Error.build_order_not_found_error()}
      order -> Repo.delete(order)
    end
  end
end
