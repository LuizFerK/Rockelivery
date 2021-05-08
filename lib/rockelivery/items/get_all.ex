defmodule Rockelivery.Items.GetAll do
  alias Rockelivery.{Item, Repo}

  def call, do: {:ok, Repo.all(Item)}
end
