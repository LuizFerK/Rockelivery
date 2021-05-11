defmodule RockeliveryWeb.Auth.GuardianTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias RockeliveryWeb.Auth.Guardian

  describe "authenticate/1" do
    setup do
      id = "87b7fad6-0ceb-40b8-9063-eb5b90815830"

      insert(:user, id: id)

      {:ok, id: id}
    end

    test "when the credentials are valid, authenticate the user", %{id: id} do
      password = "123456"

      response = Guardian.authenticate(%{"id" => id, "password" => password})

      assert {:ok, _} = response
    end

    test "when the credentials are invalid, returns an error", %{id: id} do
      password = "wrong_password"

      response = Guardian.authenticate(%{"id" => id, "password" => password})

      expected_response =
        {:error,
         %Rockelivery.Error{result: "Please verify your credentials", status: :unauthorized}}

      assert expected_response == response
    end

    test "when the user does not exists, returns an error" do
      password = "123456"

      response =
        Guardian.authenticate(%{
          "id" => "87b7fad6-0ceb-40b8-9063-eb5b90815831",
          "password" => password
        })

      expected_response =
        {:error, %Rockelivery.Error{result: "User not found", status: :not_found}}

      assert expected_response == response
    end
  end
end
