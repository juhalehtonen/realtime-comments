defmodule Realtime.Storage.TableManager do
  @moduledoc """
  This GenServer is responsible for initializing an ETS table and then
  passing its ownership to a given target process.

  If the target process crashes, ownership of the ETS table is temporarily
  passed back to the TableManager. TableManager then waits until the target
  process is running and passes the ownership of the ETS table back to it.
  """
  use GenServer
  require Logger

  def start_link(%{target_process_name: _} = state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    {:ok, state, {:continue, :init_storage}}
  end

  @doc """
  Initialize the ETS table and give away its ownership to the target process.
  """
  @impl GenServer
  def handle_continue(:init_storage, state) do
    extra_ets_options = [{:heir, self(), {}}]
    ets_table = Realtime.Storage.init(extra_ets_options)
    give_away(ets_table, state.target_process_name)
    Logger.info("Gave away ETS table ownership after initialization")

    state = Map.put(state, :table, ets_table)
    {:noreply, state}
  end

  @doc """
  Handler for the special :"ETS-TRANSFER" message which is received when ETS table
  ownership is handed over to this GenServer.
  """
  @impl GenServer
  def handle_info(
        {:"ETS-TRANSFER", table, _pid, _data},
        %{target_process_name: target_process_name} = state
      ) do
    give_away(table, target_process_name)
    Logger.info("Gave away ETS table ownership after restart")
    {:noreply, state}
  end

  ## Private helpers

  defp give_away(ets_table, target_process_name) do
    target_pid = wait_for_process(target_process_name)
    :ets.give_away(ets_table, target_pid, {})
  end

  defp wait_for_process(target_process_name) do
    target_pid = Process.whereis(target_process_name)

    if target_pid && Process.alive?(target_pid) do
      target_pid
    else
      wait_for_process(target_process_name)
    end
  end
end
