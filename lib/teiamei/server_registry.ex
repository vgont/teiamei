defmodule Teiamei.ServerRegistry do
  use GenServer
  require Logger

  def start_link(rooms) do
    GenServer.start_link(__MODULE__, rooms, name: __MODULE__)
  end

  def create(room) do
    GenServer.call(__MODULE__, {:create, room})
  end

  @impl true
  def init(rooms) do
    {:ok, rooms}
  end

  @impl true
  def handle_call({:create, room_name}, {pid, _}, state) do
    Logger.info("from: #{inspect pid} |||| self: #{inspect self()}")
    case Teiamei.Server.start_link({room_name, [pid]}) do
      {:ok, _} ->
        Logger.info("Server created")
        {:reply, :ok, [state | pid]}

      {:error, {:already_started, _}} ->
        Logger.info("Server already created")
        {:reply, :error, state}
    end
  end
end
