defmodule Realtime.Content do
  @moduledoc """
  Context module for Content.
  """
  alias Realtime.Content.Comment
  alias Realtime.Storage

  @spec list_comments() :: [list()]
  def list_comments do
    Realtime.Storage.list_rows()
  end

  @spec insert_comment(map()) :: boolean() | {:error, Ecto.Changeset.t()}
  def insert_comment(params) do
    case Comment.new(params) do
      {:ok, comment} -> Storage.insert_row(comment)
      {:error, changeset} -> {:error, changeset}
    end
  end
end
