defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

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
end
