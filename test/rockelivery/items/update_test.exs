defmodule Rockelivery.Items.UpdateTest do
  use Rockelivery.DataCase, async: true
  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Update

  describe "call/1" do
    setup do
      id = "2baadea4-1d22-4d8c-9455-2ea5d692f931"

      insert(:item, id: id)

      {:ok, id: id}
    end

    test "when all params are valid, updates the item", %{id: id} do
      params = build(:item_params, %{"id" => id})

      response = Update.call(params)

      assert {:ok, %Item{}} = response
    end

    test "when an invalid id is given, returns an error" do
      params = build(:item_params, %{"id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932"})

      response = Update.call(params)

      assert {:error, %Error{}} = response
    end

    test "when invalid params are given, returns an error", %{id: id} do
      params =
        build(:user_params, %{
          "id" => id,
          "price" => "-50.50"
        })

      response = Update.call(params)

      assert {:error, %Error{}} = response
    end
  end
end
