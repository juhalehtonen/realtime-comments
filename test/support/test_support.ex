defmodule Realtime.TestSupport do
  @moduledoc """
  Reusable functions for test setup across tests.
  """

  def reset_ets do
    Realtime.Storage.destroy()
  end
end
