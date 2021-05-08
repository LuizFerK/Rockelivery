defmodule Rockelivery do
  alias Rockelivery.Items.Create, as: ItemCreate
  alias Rockelivery.Items.Delete, as: ItemDelete
  alias Rockelivery.Items.Get, as: ItemGet
  alias Rockelivery.Items.GetAll, as: GetAllItems
  alias Rockelivery.Items.Update, as: ItemUpdate

  alias Rockelivery.Users.Create, as: UserCreate
  alias Rockelivery.Users.Delete, as: UserDelete
  alias Rockelivery.Users.Get, as: UserGet
  alias Rockelivery.Users.GetAll, as: GetAllUsers
  alias Rockelivery.Users.Update, as: UserUpdate

  alias Rockelivery.Orders.Create, as: OrderCreate
  alias Rockelivery.Orders.Delete, as: OrderDelete
  alias Rockelivery.Orders.Get, as: OrderGet
  alias Rockelivery.Orders.GetAll, as: GetAllOrders

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate delete_user(id), to: UserDelete, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate update_user(params), to: UserUpdate, as: :call
  defdelegate get_all_users(), to: GetAllUsers, as: :call

  defdelegate create_item(params), to: ItemCreate, as: :call
  defdelegate delete_item(id), to: ItemDelete, as: :call
  defdelegate get_item_by_id(id), to: ItemGet, as: :by_id
  defdelegate update_item(params), to: ItemUpdate, as: :call
  defdelegate get_all_items(), to: GetAllItems, as: :call

  defdelegate create_order(params), to: OrderCreate, as: :call
  defdelegate delete_order(id), to: OrderDelete, as: :call
  defdelegate get_order_by_id(id), to: OrderGet, as: :by_id
  defdelegate get_all_orders(), to: GetAllOrders, as: :call
end
