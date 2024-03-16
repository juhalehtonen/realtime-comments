defmodule Realtime.DataNormalizer do
  @moduledoc """
  A unified API for normalizing loosely defined data, meaning the conversion of
  string-based values into desired Elixir types.
  """

  alias Ecto.Changeset

  @doc """
  Given loosely typed `data` and a `schema`, normalizes the types of `data` to match given
  `schema`. Discards keys in `data` not present in `schema`, and can optionally validate
  that `required` keys are present in `data`.

  Returns `{:ok, normalized_params}` if data has been correctly normalized, or
  `{:error, changeset}` if there were errors in data normalization.

  ## Examples

      iex> Realtime.DataNormalizer.normalize(
      iex>   %{"id" => "123", "date" => "2024-03-16"},
      iex>   [id: :integer, date: :date]
      iex> )
      {:ok, %{id: 123, date: ~D[2024-06-16]}}

  """
  def normalize(data, schema, required \\ [])
      when is_map(data) and is_list(schema) and is_list(required) do
    types = get_types_from_schema(schema)

    {%{}, types}
    |> Changeset.cast(data, Map.keys(types))
    |> Changeset.validate_required(required)
    |> Changeset.apply_action(:insert)
  end

  # Produce a map where keys are field names, and values are their intended types
  @spec get_types_from_schema(list()) :: map()
  defp get_types_from_schema(schema) do
    Enum.into(schema, %{}, fn {name, type} -> {name, type} end)
  end
end
