defmodule Realtime.Content do
  @moduledoc """
  Context module for Content.
  """
  alias Realtime.Content.Comment
  alias Realtime.Storage

  @doc """
  List all comments for a given `post_id`.
  """
  @spec list_comments(integer()) :: list()
  def list_comments(post_id) when is_integer(post_id) do
    # TODO: Storage module API could benefit from being more generic:
    # list_rows should accept a table name and the table name could
    # be more dynamic. Currently this is fairly coupled to the `Content`.
    Realtime.Storage.get_rows_for_key(post_id) |> Enum.map(fn {_, comment} -> comment end)
  end

  @spec create_comment(map()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  def create_comment(params) when is_map(params) do
    changeset = Comment.changeset(%Comment{}, params)

    if changeset.valid? do
      {:ok, comment} =
        Ecto.Changeset.apply_action(changeset, :insert)

      comment =
        comment
        |> Map.put(:inserted_at, DateTime.utc_now())
        |> Map.put(:id, :erlang.phash2(:erlang.unique_integer()))

      Storage.insert_row(comment)

      {:ok, comment}
    else
      {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  @spec change_comment(Comment.t(), map()) :: Ecto.Changeset.t()
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  @doc """
  Returns a mock post.
  """
  @spec get_post() :: %{
          body: String.t(),
          id: integer(),
          inserted_at: DateTime.t(),
          title: String.t()
        }
  def get_post do
    %{
      id: 1,
      title: "My first post",
      body:
        "This is my first post. I hope you like it! And if you don't, please make sure to leave a comment to let me know how I can improve. After all, I'm here to learn and grow.",
      inserted_at: ~U[2024-03-17 00:07:10Z]
    }
  end
end
