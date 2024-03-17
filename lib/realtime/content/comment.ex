defmodule Realtime.Content.Comment do
  @moduledoc """
  Functions and data definitions for the `Comment` data structure.
  """

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :post_id, :integer
    field :author, :string
    field :body, :string
    field :inserted_at, :utc_datetime
  end

  def changeset(%__MODULE__{} = comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:post_id, :author, :body, :inserted_at])
    |> validate_required([:post_id, :author, :body])
  end
end
