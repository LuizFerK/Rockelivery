defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User

  describe "changeset/2" do
    test "when all params are valid, return a valid changeset" do
      params = build(:user_params)

      response = User.changeset(params)

      assert %Changeset{changes: %{name: "John Doe"}, valid?: true} = response
    end

    test "when updating a changeset, returns a valid chageset with the given changes" do
      params = build(:user_params)

      update_params = %{
        name: "Another John",
        password: "123123"
      }

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      assert %Changeset{changes: %{name: "Another John", password: "123123"}, valid?: true} =
               response
    end

    test "when there is some error, returns an invalid changeset" do
      params = build(:user_params, %{"age" => 17, "password" => "123"})

      response = User.changeset(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end

    test "when updating a changeset, if there is some error, returns an invalid changeset" do
      params = build(:user_params)

      update_params = build(:user_params, %{"age" => 17, "password" => "123"})

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
