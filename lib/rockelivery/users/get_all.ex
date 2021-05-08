defmodule Rockelivery.Users.GetAll do
  alias Rockelivery.{Repo, User}

  def call, do: {:ok, Repo.all(User)}
end
