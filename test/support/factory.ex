defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.{Item, Order, User}

  def user_params_factory do
    %{
      "age" => 18,
      "address" => "Random street, 10",
      "cep" => "01001000",
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
      cep: "01001000",
      cpf: "12345678900",
      email: "johndoe@example.com",
      password: "123456",
      password_hash:
        "$pbkdf2-sha512$160000$5zoT/vkD/v4cVTyeL9XhyA$lssj/b2OxdxiwzRnlmdMHr1PHVFa2UcNmlScYTvao9D96KVeZPHM2naWuRXCOzFOECx02O9xtgN7VRzsMwmZlA",
      name: "John Doe",
      id: "2baadea4-1d22-4d8c-9455-2ea5d692f931"
    }
  end

  def cep_info_factory do
    %{
      "bairro" => "Sé",
      "cep" => "01001-000",
      "complemento" => "lado ímpar",
      "ddd" => "11",
      "gia" => "1004",
      "ibge" => "3550308",
      "localidade" => "São Paulo",
      "logradouro" => "Praça da Sé",
      "siafi" => "7107",
      "uf" => "SP"
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

  def order_params_factory do
    %{
      "user_id" => "2baadea4-1d22-4d8c-9455-2ea5d692f931",
      "address" => "Random street, 10",
      "comments" => "Extra cheese",
      "payment_method" => "credit_card",
      "items" => [%{"id" => "2baadea4-1d22-4d8c-9455-2ea5d692f932", "quantity" => 1}]
    }
  end

  def order_factory do
    %Order{
      user_id: "2baadea4-1d22-4d8c-9455-2ea5d692f931",
      address: "Random street, 10",
      comments: "Extra cheese",
      payment_method: "credit_card",
      items: ["2baadea4-1d22-4d8c-9455-2ea5d692f932"]
    }
  end
end
