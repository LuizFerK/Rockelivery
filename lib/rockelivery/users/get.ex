defmodule Rockelivery.Users.Get do
  alias Ecto.UUID
  alias Rockelivery.{Error, Repo, User}

  def by_id(id) do
    with {:ok, uuid} <- UUID.cast(id),
         %User{} = user <- Repo.get(User, uuid) do
      {:ok, user}
    else
      :error -> {:error, Error.build_id_format_error()}
      nil -> {:error, Error.build_user_not_found_error()}
    end
  end
end
