defmodule Rockelivery.Orders.Update do
  import Ecto.Query

  alias Rockelivery.{Error, Item, Order, Repo, User}
  alias Rockelivery.Orders.ValidateAndMultiplyItems

  def call(%{"id" => id} = params) do
    items = Map.get(params, "items")
    user_id = Map.get(params, "user_id")

    with %Order{} = order <- Repo.get(Order, id),
         {:ok, items} <- validate_items(items),
         {:ok, %User{}} <- validate_user(user_id) do
      params = put_items(params, items)

      order
      |> Repo.preload([:items, :user])
      |> Order.changeset(params)
      |> Repo.update()
      |> handle_insert()
    else
      nil -> {:error, Error.build_order_not_found_error()}
      error -> error
    end
  end

  defp validate_user(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, Error.build_user_not_found_error()}
      %User{} = user -> {:ok, user}
    end
  end

  defp validate_items(items) when is_nil(items), do: {:ok, nil}

  defp validate_items(items) do
    items_ids = Enum.map(items, fn item -> item["id"] end)

    query = from item in Item, where: item.id in ^items_ids

    query
    |> Repo.all()
    |> ValidateAndMultiplyItems.call(items_ids, items)
  end

  defp put_items(order, items) when is_nil(items), do: order
  defp put_items(order, items), do: Map.put(order, "items", items)

  defp handle_insert({:ok, %Order{} = order}), do: {:ok, Repo.preload(order, :user, force: true)}
  defp handle_insert({:error, result}), do: {:error, Error.build(:bad_request, result)}
end
