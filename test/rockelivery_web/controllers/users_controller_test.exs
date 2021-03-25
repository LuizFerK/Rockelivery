defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = build(:user_params)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      expected_response = %{
        "message" => "User created!",
        "user" => %{
          "address" => "Random street, 10",
          "age" => 18,
          "cep" => "12345000",
          "cpf" => "12345678900",
          "email" => "johndoe@example.com",
          "name" => "John Doe"
        }
      }

      assert response == expected_response
    end

    test "when there is some error, returns the error", %{conn: conn} do
      params = build(:user_params, %{"age" => 15, "password" => "123"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "error" => %{
          "age" => ["must be greater than or equal to 18"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "when there is an user with the given id, deletes the user", %{conn: conn} do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end
  end
end
