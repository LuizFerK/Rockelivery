defmodule Rockelivery.Users.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Get

  describe "by_id/1" do
    test "when the user with the given id exists, returns an user" do
      id = "675d8596-9950-4059-a1cd-ed1a2ec3d18d"

      insert(:user, id: id)

      response = Get.by_id(id)

      assert {:ok,
              %User{
                address: "Random street, 10",
                age: 18,
                cep: "01001000",
                cpf: "12345678900",
                email: "johndoe@example.com",
                id: "675d8596-9950-4059-a1cd-ed1a2ec3d18d",
                name: "John Doe",
                password: nil,
                password_hash: nil
              }} = response
    end

    test "when the user with the given id does not exists, returns an error" do
      response = Get.by_id("675d8596-9950-4059-a1cd-ed1a2ec3d18d")

      {:error, %Error{status: :not_found, result: error}} = response

      assert error == "User not found"
    end
  end
end
