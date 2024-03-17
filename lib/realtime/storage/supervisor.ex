defmodule Realtime.Storage.Supervisor do
  @moduledoc """
  Supervisor for processes responsible for ETS Storage.
  """
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Realtime.Storage.TableManager, %{target_process_name: Realtime.Storage.TableOwner}},
      {Realtime.Storage.TableOwner, []}
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
