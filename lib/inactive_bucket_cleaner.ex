use Croma

defmodule Foretoken.InactiveBucketCleaner do
  use GenServer
  alias Foretoken.{Ets, Config}

  defun start_link([]) :: GenServer.on_start do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @impl true
  def init(:ok) do
    {:ok, %{}, Config.bucket_cleanup_interval()}
  end

  @impl true
  def handle_info(:timeout, state) do
    threshold = System.monotonic_time(:millisecond) - Config.inactive_threshold()
    Ets.delete_all_stale(threshold)
    {:noreply, state, Config.bucket_cleanup_interval()}
  end
end
