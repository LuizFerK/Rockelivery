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
             cep: "01001000",
             cpf: _,
             email: _,
             id: _,
             inserted_at: nil,
             name: "John Doe",
             password: "123456",
             updated_at: nil
           } = response
  end
end
