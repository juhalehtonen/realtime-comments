defmodule Realtime.Content.Comment do
  @moduledoc """
  Functions and data definitions for the `Comment` data structure.
  """

  defstruct [
    :id,
    :post_id,
    :author,
    :body
  ]

  @type t :: %__MODULE__{
          id: non_neg_integer(),
          post_id: non_neg_integer(),
          author: String.t(),
          body: String.t()
        }

  @doc """
  Creates a new Comment from a map of parameters, casting the parameters to the expected types.

  ## Examples

      iex> Realtime.Content.Comment.new(%{
      ...>   author: "Mr. America",
      ...>   body: "New York City is the best city in the world!",
      ...>   id: "123",
      ...>   post_id: "456"
      ...> })
      %Realtime.Content.Comment{
        author: "Mr. America",
        body: "New York City is the best city in the world!",
        id: 123,
        post_id: 456,
      }
  """

  @spec new(map()) :: {:ok, __MODULE__.t()} | {:error, Ecto.Changeset.t()}
  def new(params) do
    schema = [
      id: :integer,
      post_id: :integer,
      author: :string,
      body: :string
    ]

    required = [
      :id,
      :post_id,
      :author,
      :body
    ]

    case Realtime.DataNormalizer.normalize(params, schema, required) do
      {:ok, value} -> {:ok, struct(__MODULE__, value)}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
