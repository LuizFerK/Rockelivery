defmodule RockeliveryWeb.UsersView do
  use RockeliveryWeb, :view

  alias Rockelivery.User

  def render("create.json", %{user: %User{} = user, token: token}) do
    %{
      token: token,
      user: user
    }
  end

  def render("sign_in.json", %{token: token}), do: %{token: token}

  def render("user.json", %{user: %User{} = user}), do: user

  def render("users.json", %{users: [%User{} | _] = users}), do: users
end
