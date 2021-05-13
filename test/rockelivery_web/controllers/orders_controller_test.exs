defmodule RockeliveryWeb.OrdersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  alias RockeliveryWeb.Auth.Guardian
  alias Rockelivery.{Item, User}

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      item = insert(:item)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user_id: user.id, item_id: item.id}
    end

    test "when all params are valid, creates the order", %{
      conn: conn,
      user_id: user_id,
      item_id: item_id
    } do
      params =
        build(:order_params, %{
          "user_id" => user_id,
          "items" => [%{"id" => item_id, "quantity" => 1}]
        })

      response =
        conn
        |> post(Routes.orders_path(conn, :create), params)
        |> json_response(:created)

      assert %{
               "address" => "Random street, 10",
               "comments" => "Extra cheese",
               "id" => _,
               "items" => [
                 %{
                   "category" => "food",
                   "description" => "Pepperoni Pizza",
                   "id" => _,
                   "photo" => "/priv/photo/pepperoni_pizza.jpg",
                   "price" => "59.90"
                 }
               ],
               "payment_method" => "credit_card",
               "user" => %{
                 "address" => "Random street, 10",
                 "age" => 18,
                 "cep" => "01001000",
                 "cpf" => _,
                 "email" => _,
                 "id" => _,
                 "name" => "John Doe"
               },
               "user_id" => _
             } = response
    end

    test "when there are invalid params, returns an error", %{
      conn: conn,
      user_id: user_id,
      item_id: item_id
    } do
      params =
        build(:order_params, %{
          "comments" => 123,
          "user_id" => user_id,
          "items" => [%{"id" => item_id, "quantity" => 1}]
        })

      response =
        conn
        |> post(Routes.orders_path(conn, :create), params)
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"comments" => ["is invalid"]}}

      assert response == expected_response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      item = insert(:item)
      order = insert(:order, user_id: user.id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order_id: order.id}
    end

    test "when there is an order with the given id, deletes the order", %{
      conn: conn,
      order_id: order_id
    } do
      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, order_id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is no order with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Order not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.orders_path(conn, :delete, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      user = insert(:user)
      item = insert(:item)

      order1 = insert(:order, user_id: user.id, items: [item])
      order2 = insert(:order, user_id: user.id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order1_id: order1.id, order2_id: order2.id}
    end

    test "should return all orders", %{conn: conn, order1_id: order1_id, order2_id: order2_id} do
      response =
        conn
        |> get(Routes.orders_path(conn, :index))
        |> json_response(:ok)

      assert [
               %{
                 "address" => "Random street, 10",
                 "comments" => "Extra cheese",
                 "id" => ^order1_id,
                 "items" => [
                   %{
                     "id" => _
                   }
                 ],
                 "payment_method" => "credit_card",
                 "user" => %{
                   "id" => _
                 },
                 "user_id" => _
               },
               %{
                 "id" => ^order2_id,
                 "items" => [
                   %{
                     "id" => _
                   }
                 ],
                 "payment_method" => "credit_card",
                 "user" => %{
                   "id" => _
                 },
                 "user_id" => _
               }
             ] = response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      user = insert(:user)
      item = insert(:item)

      order = insert(:order, user_id: user.id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order_id: order.id}
    end

    test "when there is an order with the given id, returns the order", %{
      conn: conn,
      order_id: order_id
    } do
      response =
        conn
        |> get(Routes.orders_path(conn, :show, order_id))
        |> json_response(:ok)

      assert %{
               "address" => "Random street, 10",
               "comments" => "Extra cheese",
               "id" => ^order_id,
               "items" => [
                 %{
                   "id" => _
                 }
               ],
               "payment_method" => "credit_card",
               "user" => %{
                 "id" => _
               },
               "user_id" => _
             } = response
    end

    test "when there is no order with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.orders_path(conn, :show, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Order not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.orders_path(conn, :show, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      user = insert(:user)
      item = insert(:item)

      order = insert(:order, user_id: user.id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: order.id}
    end

    test "when there is an order with the given id, update the order", %{conn: conn, id: id} do
      %User{id: user_id} = insert(:user)
      %Item{id: item_id} = insert(:item)

      params = %{
        "comments" => "Extra sauce",
        "user_id" => user_id,
        "items" => [%{"id" => item_id, "quantity" => 1}]
      }

      response =
        conn
        |> put(Routes.orders_path(conn, :update, id), params)
        |> json_response(:ok)

      assert %{
               "address" => "Random street, 10",
               "comments" => "Extra sauce",
               "id" => _,
               "items" => [
                 %{
                   "category" => "food",
                   "description" => "Pepperoni Pizza",
                   "id" => ^item_id,
                   "photo" => "/priv/photo/pepperoni_pizza.jpg",
                   "price" => "59.90"
                 }
               ],
               "payment_method" => "credit_card",
               "user" => %{
                 "address" => "Random street, 10",
                 "age" => 18,
                 "cep" => "01001000",
                 "cpf" => _,
                 "email" => _,
                 "id" => ^user_id,
                 "name" => "John Doe"
               },
               "user_id" => ^user_id
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, id: id} do
      params = %{"payment_method" => "invalid_payment_method"}

      response =
        conn
        |> put(Routes.orders_path(conn, :update, id), params)
        |> json_response(:bad_request)

      assert %{"error" => %{"payment_method" => ["is invalid"]}} = response
    end

    test "when there is no order with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.orders_path(conn, :update, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "Order not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.orders_path(conn, :update, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end

    test "when the user_id format is invalid, returns an error", %{conn: conn, id: id} do
      params = %{"user_id" => "invalid_id"}

      response =
        conn
        |> put(Routes.orders_path(conn, :update, id), params)
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end
end
