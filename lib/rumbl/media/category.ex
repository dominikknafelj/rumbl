defmodule Rumbl.Media.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Media.Category


  schema "media_categories" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
