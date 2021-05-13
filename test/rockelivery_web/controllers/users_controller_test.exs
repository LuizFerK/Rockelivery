defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.ViaCep.ClientMock
  alias RockeliveryWeb.Auth.Guardian

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "user" => %{
                 "address" => "Random street, 10",
                 "age" => 18,
                 "cep" => "01001000",
                 "cpf" => _,
                 "email" => _,
                 "name" => "John Doe"
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      params = build(:user_params, %{"age" => "invalid_param"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"age" => ["is invalid"]}}

      assert response == expected_response
    end

    test "when the email is already taken, returns an error", %{conn: conn} do
      email = "johndoe@example.com"

      insert(:user, email: email)

      params = build(:user_params, %{"email" => email})

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"email" => ["has already been taken"]}}

      assert response == expected_response
    end

    test "when the cpf is already taken, returns an error", %{conn: conn} do
      cpf = "12345678900"

      insert(:user, email: "other@email.com", cpf: cpf)

      params = build(:user_params, %{"cpf" => cpf})

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{"error" => %{"cpf" => ["has already been taken"]}}

      assert response == expected_response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      user = insert(:user, id: id)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "when there is an user with the given id, deletes the user", %{conn: conn, id: id} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "when there is no user with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "User not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "index/2" do
    setup do
      user1_id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"
      user2_id = "2baadea4-1d22-4d8c-9455-2ea5d692f932"

      user = insert(:user, id: user1_id)
      insert(:user, id: user2_id, cpf: "12345678901", email: "test@example.com")

      {:ok, user: user, user1_id: user1_id, user2_id: user2_id}
    end

    test "should return all users", %{
      conn: conn,
      user: user,
      user1_id: user1_id,
      user2_id: user2_id
    } do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(Routes.users_path(conn, :index))
        |> json_response(:ok)

      assert [%{"id" => ^user1_id}, %{"id" => ^user2_id}] = response
    end

    test "when user is not authenticated, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(:unauthorized)

      assert %{"message" => "unauthenticated"} = response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      user = insert(:user, id: id)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "when there is an user with the given id, returns the user", %{conn: conn, id: id} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "address" => "Random street, 10",
               "age" => 18,
               "cep" => "01001000",
               "cpf" => _,
               "email" => _,
               "name" => "John Doe"
             } = response
    end

    test "when there is no user with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "User not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end

  describe "sign_in/2" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:user, id: id)

      {:ok, id: id}
    end

    test "when the credentials are valid, authenticate the user", %{conn: conn, id: id} do
      params = %{"id" => id, "password" => "123456"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:ok)

      assert %{"token" => _} = response
    end

    test "when the credentials are invalid, returns an error", %{conn: conn, id: id} do
      params = %{"id" => id, "password" => "wrong_password"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:unauthorized)

      assert %{"error" => "Please verify your credentials"} = response
    end

    test "when the user does not exists, returns an error", %{conn: conn} do
      params = %{"id" => "2baadea4-1d22-4d8c-9455-2ea5d692f930", "password" => "wrong_password"}

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, params))
        |> json_response(:not_found)

      assert %{"error" => "User not found"} = response
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      user = insert(:user, id: id)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: id}
    end

    test "when there is an user with the given id, update the user", %{conn: conn, id: id} do
      params = %{"age" => 20, "password" => "654321"}

      response =
        conn
        |> put(Routes.users_path(conn, :update, id, params))
        |> json_response(:ok)

      assert %{
               "id" => "2baadea4-1d22-4d8c-9455-2ea5d692f931",
               "address" => "Random street, 10",
               "age" => 20,
               "cep" => "01001000",
               "cpf" => _,
               "email" => _,
               "name" => "John Doe"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, id: id} do
      params = %{"password" => "123"}

      response =
        conn
        |> put(Routes.users_path(conn, :update, id, params))
        |> json_response(:bad_request)

      assert %{"error" => %{"password" => ["should be at least 6 character(s)"]}} = response
    end

    test "when there is no user with the given id, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.users_path(conn, :update, "2baadea4-1d22-4d8c-9455-2ea5d692f932"))
        |> json_response(:not_found)

      assert response == %{"error" => "User not found"}
    end

    test "when the id format is invalid, returns an error", %{conn: conn} do
      response =
        conn
        |> put(Routes.users_path(conn, :update, "invalid_id"))
        |> json_response(:bad_request)

      assert response == %{"message" => "Invalid id format"}
    end
  end
end
