defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.{Item, User}

  def user_params_factory do
    %{
      "age" => 18,
      "address" => "Random street, 10",
      "cep" => "12345000",
      "cpf" => "12345678900",
      "email" => "johndoe@example.com",
      "password" => "123456",
      "name" => "John Doe"
    }
  end

  def user_factory do
    %User{
      age: 18,
      address: "Random street, 10",
      cep: "12345000",
      cpf: "12345678900",
      email: "johndoe@example.com",
      password: "123456",
      name: "John Doe",
      id: "2baadea4-1d22-4d8c-9455-2ea5d692f931"
    }
  end

  def item_params_factory do
    %{
      "category" => "food",
      "description" => "Chocolate Pizza",
      "price" => "49.90",
      "photo" => "/priv/photo/chocolate_pizza.jpg"
    }
  end

  def item_factory do
    %Item{
      category: "food",
      description: "Pepperoni Pizza",
      price: "59.90",
      photo: "/priv/photo/pepperoni_pizza.jpg",
      id: "2baadea4-1d22-4d8c-9455-2ea5d692f932"
    }
  end
end
