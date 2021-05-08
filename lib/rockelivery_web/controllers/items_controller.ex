defmodule RockeliveryWeb.ItemsController do
  use RockeliveryWeb, :controller

  alias Rockelivery.Item
  alias RockeliveryWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Item{} = item} <- Rockelivery.create_item(params) do
      conn
      |> put_status(:created)
      |> render("item.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Item{}} <- Rockelivery.delete_item(id) do
      conn
      |> put_status(:no_content)
      |> text("")
    end
  end

  def index(conn, _params) do
    with {:ok, [%Item{} | _] = items} <- Rockelivery.get_all_items() do
      conn
      |> put_status(:ok)
      |> render("items.json", items: items)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Item{} = item} <- Rockelivery.get_item_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("item.json", item: item)
    end
  end

  def update(conn, params) do
    with {:ok, %Item{} = item} <- Rockelivery.update_item(params) do
      conn
      |> put_status(:ok)
      |> render("item.json", item: item)
    end
  end
end
