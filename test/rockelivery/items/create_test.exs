defmodule Rockelivery.Items.CreateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Create

  describe "call/1" do
    test "when all params are valid, returns an item" do
      params = build(:item_params)

      response = Create.call(params)

      assert {:ok, %Item{id: _id, description: "Chocolate Pizza"}} = response
    end

    test "when there are invalid params, returns an error" do
      params = build(:user_params, %{"price" => "-50.10"})

      assert {:error, %Error{status: :bad_request, result: changeset}} = Create.call(params)

      expected_response = %{
        category: ["can't be blank"],
        description: ["can't be blank"],
        photo: ["can't be blank"],
        price: ["must be greater than 0"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
