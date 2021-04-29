defmodule Rockelivery.Items.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Get

  describe "by_id/1" do
    test "when the item with the given id exists, returns an item" do
      id = "675d8596-9950-4059-a1cd-ed1a2ec3d18d"

      insert(:item, id: id)

      response = Get.by_id(id)

      assert {:ok,
              %Item{
                category: :food,
                description: "Pepperoni Pizza",
                photo: "/priv/photo/pepperoni_pizza.jpg"
              }} = response
    end

    test "when the item with the given id does not exists, returns an error" do
      response = Get.by_id("675d8596-9950-4059-a1cd-ed1a2ec3d18d")

      {:error, %Error{status: :not_found, result: error}} = response

      assert error == "Item not found"
    end
  end
end
