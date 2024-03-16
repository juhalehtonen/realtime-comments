defmodule Realtime.DataNormalizer do
  @moduledoc """
  A unified API for normalizing loosely defined data, meaning the conversion of
  string-based values into desired Elixir types.
  """

  alias Ecto.Changeset

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
