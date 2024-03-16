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

  @spec new!(map()) :: __MODULE__.t()
  def new!(params) do
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

    {:ok, value} = Realtime.DataNormalizer.normalize(params, schema, required)

    struct(__MODULE__, value)
  end
end
