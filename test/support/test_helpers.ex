defmodule Rumbl.TestHelpers do
  alias Rumbl.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(
      %{
        name: "Some User",
        username: "user#{Base.encode(:crypto.rand_bytes(8))}",
        password: "supergeheim"
      },
      attrs
    )

    %Rumbl.Users.User{}
    |> Rumbl.Users.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attr \\ {}) do
    user
    |> Ecto.build_assoc(:video, attrs)
    |> Repo.insert!()
  end
end