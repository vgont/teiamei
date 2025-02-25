defmodule Teiamei.Server do
  use GenServer
  require Logger

  def send_message(room_name, message) do
    GenServer.call({:via, Registry, {Teiamei.Registry, room_name}}, {:send, message})
  end

  def add_member(room_name, member) do
    GenServer.call({:via, Registry, {Teiamei.Registry, room_name}}, {:add_member, member})
  end

  def hello(room_name) do
    GenServer.call({:via, Registry, {Teiamei.Registry, room_name}}, :hello)
  end

  def start_link({room_name, members}) do
    GenServer.start_link(__MODULE__, members,
      name: {:via, Registry, {Teiamei.Registry, room_name}}
    )
  end

  @impl true
  @spec init(members :: [pid()]) :: {:ok, members :: [pid()]}
  def init(members) do
    {:ok, members}
  end

  def handle_call({:add_member, member}, _from, members) do
    {:reply, :ok, [member | members]}
  end

  @impl true
  def handle_call({:send, message}, {pid, _}, members) do
    Enum.reject(members, fn member -> member == pid end)
    |>Enum.each(fn member -> send(member, {:send, message}) end)
    {:reply, :ok, members}
  end

  @impl true
  def handle_call(:hello, _from, members) do
    {:reply, "hello", members}
  end
end
