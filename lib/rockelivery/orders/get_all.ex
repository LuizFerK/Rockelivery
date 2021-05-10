defmodule Rockelivery.Orders.GetAll do
  alias Rockelivery.{Order, Repo}

  def call do
    orders =
      Order
      |> Repo.all()
      |> Repo.preload([:items, :user])

    {:ok, orders}
  end
end
