defmodule Rockelivery.Factory do
  use ExMachina

  def user_params_factory do
    %{
      age: 18,
      address: "Random street, 10",
      cep: "12345000",
      cpf: "12345678900",
      email: "johndoe@example.com",
      password: "123456",
      name: "John Doe"
    }
  end
end
