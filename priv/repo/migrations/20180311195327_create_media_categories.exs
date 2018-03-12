defmodule Rumbl.Repo.Migrations.CreateMediaCategories do
  use Ecto.Migration

  def change do
    create table(:media_categories) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:media_categories, [:name])
  end
end
