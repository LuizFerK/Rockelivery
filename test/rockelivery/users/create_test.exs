defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Create
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep -> {:ok, build(:cep_info)} end)

      response = Create.call(params)

      assert {:ok, %User{id: _id, age: 18, email: "johndoe@example.com"}} = response
    end

    test "when there are invalid params, returns an error" do
      params = build(:user_params, %{"age" => 17, "password" => "123"})

      assert {:error, %Error{status: :bad_request, result: changeset}} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_response
    end

    test "when the cep does not exists, returns an error" do
      params = build(:user_params, %{"cep" => "00000000"})

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:error, Error.build(:not_found, "CEP not found")}
      end)

      response = Create.call(params)

      assert {:error, %Rockelivery.Error{result: "CEP not found", status: :not_found}} = response
    end
  end
end
