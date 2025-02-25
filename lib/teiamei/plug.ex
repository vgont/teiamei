defmodule Teiamei.Plug do
  alias Teiamei.Server
  alias Teiamei.ServerRegistry
  import Plug.Conn
  use Plug.Router
  require Logger

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/" do
    conn = send_resp(conn, 200, build_msg("hello"))
    conn
  end

  get "create/:server_name" do
    case ServerRegistry.create(server_name) do
      :ok -> send_resp(conn, 201, build_msg("Server created"))
      :error -> send_resp(conn, 400, build_msg("Server already exists"))
    end
  end

  get "/ws/:server_name" do
    Server.add_member(server_name, self())
    conn
    |> WebSockAdapter.upgrade(Teiamei.Websocket, server_name, timeout: :infinity)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp build_msg(msg) do
    Poison.encode!(%{message: msg})
  end
end
