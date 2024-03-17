defmodule Realtime.Content do
  @moduledoc """
  Context module for Content.
  """
  alias Realtime.Content.Comment
  alias Realtime.Storage

  def list_comments(key) when is_integer(key) do
    # TODO: Storage module API could benefit from being more generic:
    # list_rows should accept a table name and the table name could
    # be more dynamic.
    Realtime.Storage.get_rows_for_key(key) |> Enum.map(fn {_, comment} -> comment end)
  end

  @spec create_comment(map()) :: {:ok, any()} | {:error, Ecto.Changeset.t()}
  def create_comment(params) do
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
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  @doc """
  Returns a mock post.
  """
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
