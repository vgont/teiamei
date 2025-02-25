defmodule Teiamei.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Teiamei.Registry},
      {Bandit, plug: Teiamei.Plug},
      {Teiamei.ServerRegistry, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teiamei.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
