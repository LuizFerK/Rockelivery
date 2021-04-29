defmodule RockeliveryWeb.ItemsControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params are valid, creates the item", %{conn: conn} do
      params = build(:item_params)

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "category" => "food",
               "description" => "Chocolate Pizza",
               "photo" => "/priv/photo/chocolate_pizza.jpg",
               "price" => "49.90"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = build(:item_params, %{"price" => "-50.50"})

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"price" => ["must be greater than 0"]}}

      assert response == expected_response
    end
  end

  describe "delete/2" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:item, id: id)

      {:ok, id: id}
    end

    test "when there is an item with the given id, deletes the item", %{conn: conn, id: id} do
      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is no item with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.items_path(conn, :delete, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Item not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.items_path(conn, :delete, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "show/2" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:item, id: id)

      {:ok, id: id}
    end

    test "when there is an item with the given id, returns the item", %{conn: conn, id: id} do
      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "category" => "food",
               "description" => "Pepperoni Pizza",
               "photo" => "/priv/photo/pepperoni_pizza.jpg",
               "price" => "59.90"
             } = response
    end

    test "when there is no item with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.items_path(conn, :show, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Item not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.items_path(conn, :show, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "update/2" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:item, id: id)

      {:ok, id: id}
    end

    test "when there is an item with the given id, update the item", %{conn: conn, id: id} do
      params = %{"description" => "Chicken Pizza", "price" => "42.90"}

      response =
        conn
        |> put(Routes.items_path(conn, :update, id, params))
        |> json_response(:ok)

      assert %{
               "category" => "food",
               "description" => "Chicken Pizza",
               "photo" => "/priv/photo/pepperoni_pizza.jpg",
               "price" => "42.90"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, id: id} do
      params = %{"price" => "-50.50"}

      response =
        conn
        |> put(Routes.items_path(conn, :update, id, params))
        |> json_response(:bad_request)

      assert %{"error" => %{"price" => ["must be greater than 0"]}} = response
    end

    test "when there is no item with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.items_path(conn, :update, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Item not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.items_path(conn, :update, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end
end
