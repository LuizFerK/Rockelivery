defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias Rockelivery.User
  alias RockeliveryWeb.UsersView

  test "renders user.json" do
    user = build(:user)

    response = render(UsersView, "user.json", user: user)

    assert %User{
             address: "Random street, 10",
             age: 18,
             cep: "12345000",
             cpf: "12345678900",
             email: "johndoe@example.com",
             id: "2baadea4-1d22-4d8c-9455-2ea5d692f931",
             inserted_at: nil,
             name: "John Doe",
             password: "123456",
             password_hash: nil,
             updated_at: nil
           } = response
  end
end
