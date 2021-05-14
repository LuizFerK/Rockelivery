# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rockelivery.Repo.insert!(%Rockelivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Rockelivery.{Item, Order, Repo, User}

user = %User{
  age: 18,
  address: "Random street, 10",
  cep: "01001000",
  cpf: "12345678909",
  email: "random@email.com",
  password: "123456",
  name: "John Doe"
}

%User{id: user_id} = Repo.insert!(user)

item1 = %Item{
  category: :food,
  description: "Cheese Pizza",
  price: Decimal.new("50.25"),
  photo: "priv/photos/cheese_pizza.png"
}

item2 = %Item{
  category: :drink,
  description: "Chocolate milk",
  price: Decimal.new("5.90"),
  photo: "priv/photos/chocolate_milk.png"
}

Repo.insert!(item1)
Repo.insert!(item2)

order = %Order{
  user_id: user_id,
  items: [item1, item1, item2],
  address: "Random street, 10",
  comments: "Without cheddar",
  payment_method: :credit_card
}

Repo.insert!(order)
