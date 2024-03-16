defmodule Realtime.Storage do
  @moduledoc """
  Storage API that wraps ETS operations to persist data in-memory.
  """
  @ets_table_name :content
  @ets_default_options [:named_table, :bag, :public, read_concurrency: true]

  @doc """
  Creates a new ETS table using #{inspect(@ets_default_options)} as the base
  options and merges them with the given `extra_options`.
  """
  def init(extra_options) when is_list(extra_options) do
    ets_options = @ets_default_options ++ extra_options
    :ets.new(@ets_table_name, ets_options)
  end

  @doc """
  Inserts a new row.

  The `:post_id` of the comment is used as the key.
  """
  def insert_row(data) when is_map(data) do
    :ets.insert(
      @ets_table_name,
      {data.post_id, data}
    )
  end

  @doc """
  Get all rows.
  """
  @spec list_rows() :: [any()]
  def list_rows do
    :ets.match(@ets_table_name, :"$1")
  end

  @doc """
  Get all rows under the same `key`.
  """
  @spec get_rows_for_key(any()) :: [any()]
  def get_rows_for_key(key) do
    :ets.lookup(@ets_table_name, key)
  end

  @doc """
  Delete all rows in the ETS table.
  """
  @spec destroy() :: true
  def destroy do
    :ets.delete_all_objects(@ets_table_name)
  end
end
