defmodule Realtime.Storage.TableOwner do
  @moduledoc """
  GenServer responsible for owning and using the ETS table.

  This is a contrived example, but in a real world scenario, perhaps this process does
  something periodically and could crash if that failed. If so, the `TableManager` will
  temporarily take ownership while `TableOwner` gets restarted.

  This approach is also documented in https://www.erlang.org/doc/man/ets.html#give_away-3
  """
  use GenServer
  require Logger

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @doc """
  Handler for the special :"ETS-TRANSFER" message which is received when ETS table
  ownership is handed over to this GenServer.
  """
  @impl GenServer
  def handle_info({:"ETS-TRANSFER", table, _manager_pid, _data}, _state) do
    Logger.info("Received ETS table ownership")
    new_state = table
    {:noreply, new_state}
  end
end
