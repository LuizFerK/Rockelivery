defmodule RockeliveryWeb.OrdersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  alias RockeliveryWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      item_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      user = insert(:user, id: user_id)
      insert(:item, id: item_id)

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user_id: user_id, item_id: item_id}
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
        |> post(Routes.orders_path(conn, :create, params))
        |> json_response(:created)

      assert "123" = response
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
          "items" => %{
            0 => %{"id" => item_id, "quantity" => 1}
          }
        })

      response =
        conn
        |> post(Routes.orders_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = "123"

      assert response == expected_response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      user = insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order_id, user_id: user_id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order_id: order_id}
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
      order1_id = "b925ffac-7a13-43e1-9a0a-64639b140720"
      order2_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      user = insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order1_id, user_id: user_id, items: [item])
      insert(:order, id: order2_id, user_id: user_id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order1_id: order1_id, order2_id: order2_id}
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
                     "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932"
                   }
                 ],
                 "payment_method" => "credit_card",
                 "user" => %{
                   "id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
                 },
                 "user_id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
               },
               %{
                 "id" => ^order2_id,
                 "items" => [
                   %{
                     "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932"
                   }
                 ],
                 "payment_method" => "credit_card",
                 "user" => %{
                   "id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
                 },
                 "user_id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
               }
             ] = response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      order_id = "b925ffac-7a13-43e1-9a0a-64639b140721"
      user_id = "b925ffac-7a13-43e1-9a0a-64639b140722"

      user = insert(:user, id: user_id)
      item = insert(:item)

      insert(:order, id: order_id, user_id: user_id, items: [item])

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, order_id: order_id}
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
                   "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932"
                 }
               ],
               "payment_method" => "credit_card",
               "user" => %{
                 "id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
               },
               "user_id" => "b925ffac-7a13-43e1-9a0a-64639b140722"
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

  # describe "update/2" do
  #   setup %{conn: conn} do
  #     id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

  #     user = insert(:user, id: id)
  #     {:ok, token, _claims} = Guardian.encode_and_sign(user)

  #     conn = put_req_header(conn, "authorization", "Bearer #{token}")

  #     {:ok, conn: conn, id: id}
  #   end

  #   test "when there is an user with the given id, update the user", %{conn: conn, id: id} do
  #     params = %{"age" => 20, "password" => "654321"}

  #     response =
  #       conn
  #       |> put(Routes.users_path(conn, :update, id, params))
  #       |> json_response(:ok)

  #     assert %{
  #              "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f931",
  #              "address" => "Random street, 10",
  #              "age" => 20,
  #              "cep" => "01001000",
  #              "cpf" => "12345678900",
  #              "email" => "johndoe@example.com",
  #              "name" => "John Doe"
  #            } = response
  #   end

  #   test "when there are invalid params, returns an error", %{conn: conn, id: id} do
  #     params = %{"password" => "123"}

  #     response =
  #       conn
  #       |> put(Routes.users_path(conn, :update, id, params))
  #       |> json_response(:bad_request)

  #     assert %{"error" => %{"password" => ["should be at least 6 character(s)"]}} = response
  #   end

  #   test "when there is no user with the given id, returns an error", %{conn: conn} do
  #     response =
  #       conn
  #       |> put(Routes.users_path(conn, :update, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
  #       |> json_response(:not_found)

  #     assert response == %{"error" => "User not found"}
  #   end

  #   test "when the id format is invalid, returns an error", %{conn: conn} do
  #     response =
  #       conn
  #       |> put(Routes.users_path(conn, :update, "invalid_id"))
  #       |> json_response(:bad_request)

  #     assert response == %{"message" => "Invalid id format"}
  #   end
  # end
end
