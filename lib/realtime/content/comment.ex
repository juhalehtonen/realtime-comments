defmodule Realtime.Content.Comment do
  @moduledoc """
  Functions and data definitions for the `Comment` data structure.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer() | nil,
          post_id: integer() | nil,
          body: String.t() | nil,
          author: String.t() | nil,
          inserted_at: DateTime.t() | nil
        }

  embedded_schema do
    field :post_id, :integer
    field :author, :string
    field :body, :string
    field :inserted_at, :utc_datetime
  end

  @spec changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:post_id, :author, :body, :inserted_at])
    |> validate_required([:post_id, :author, :body])
  end
end
