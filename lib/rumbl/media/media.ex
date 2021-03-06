defmodule Rumbl.Media do
  require IEx
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  import Ecto
  alias Rumbl.Repo

  alias Rumbl.Media.Video
  alias Rumbl.Users.User
  alias Rumbl.Media.Category

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos(%User{} = user) do
    Repo.all(user_videos(user))
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(%User{} = user, attrs \\ %{}) do
    user
    |> build_assoc(:videos)
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  def new_video_for_user(%User{} = user) do
    user
    |> build_assoc(:videos)
    |> Video.changeset(%{})
  end

  defp user_videos(user) do
    assoc(user, :videos)
  end

  def load_categories do
    query =
      Category
      |> alphabetical
      |> names_and_ids
    Repo.all query
  end

  def alphabetical(query) do
    from category in query, order_by: category.name
  end

  def names_and_ids(query) do
    from category in query, select: {category.name, category.id}
  end
end
