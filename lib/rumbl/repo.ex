defmodule Rumbl.Repo do
  use Ecto.Repo, otp_app: :rumbl
  # @moduledoc """
  # In Memory repoository.
  # """

  # def all(Rumbl.User) do
  #   [
  #     %Rumbl.User{id: "1", name: "Dominik", username: "dknafelj", password: "password"},
  #     %Rumbl.User{id: "2", name: "James", username: "pupus", password: "password"},
  #     %Rumbl.User{id: "3", name: "Ivette", username: "star", password: "password"}
  #   ]
  # end
  # def all(_module), do: []

  # def get(module, id) do
  #   Enum.find all(module), fn map -> map.id == id end
  # end

  # def get_by(module, params) do
  #   Enum.find all(module), fn map ->
  #     Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
  #   end
  # end

    @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
