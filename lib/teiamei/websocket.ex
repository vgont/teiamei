defmodule Teiamei.Websocket do
  require Logger
  def init(room_name), do: {:ok, %{room: room_name}}

  def handle_in({msg, [opcode: :text]}, state) do
    Teiamei.Server.send_message(state.room, msg)
    {:ok, state}
  end

  def handle_info({:send, msg}, state), do: {:push, {:text, msg}, state}
end
