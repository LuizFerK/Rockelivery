defmodule Rockelivery.ItemTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.Item

  describe "changeset/2" do
    test "when all params are valid, return a valid changeset" do
      params = build(:item_params)

      response = Item.changeset(params)

      assert %Changeset{changes: %{description: "Chocolate Pizza"}, valid?: true} = response
    end

    test "when updating a changeset, returns a valid chageset with the given changes" do
      params = build(:item_params)

      update_params = %{
        description: "Cheddar Pizza",
        price: "52.30"
      }

      response =
        params
        |> Item.changeset()
        |> Item.changeset(update_params)

      assert %Changeset{changes: %{description: "Cheddar Pizza"}, valid?: true} = response
    end

    test "when there is some error, returns an invalid changeset" do
      params = build(:item_params, %{"description" => 15, "price" => "-50.10"})

      response = Item.changeset(params)

      expected_response = %{description: ["is invalid"], price: ["must be greater than 0"]}

      assert errors_on(response) == expected_response
    end

    test "when updating a changeset, if there is some error, returns an invalid changeset" do
      params = build(:item_params)

      update_params = build(:item_params, %{"description" => 15, "price" => "-50.10"})

      response =
        params
        |> Item.changeset()
        |> Item.changeset(update_params)

      expected_response = %{description: ["is invalid"], price: ["must be greater than 0"]}

      assert errors_on(response) == expected_response
    end
  end
end
