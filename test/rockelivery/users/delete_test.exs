defmodule Rockelivery.Users.DeleteTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Delete

  describe "call/1" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:user, id: id)

      {:ok, id: id}
    end

    test "when a valid id is given, delete the user", %{id: id} do
      response = Delete.call(id)

      assert {:ok, %User{}} = response
    end

    test "when an invalid id is given, returns an error" do
      response = Delete.call("2baadea4-1d22-4d8c-9455-2ea5d692f932")

      assert {:error, %Error{result: "User not found", status: :not_found}} = response
    end
  end
end
