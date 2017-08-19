defmodule KV.Supervisor do
  use Supervisor

  ## Client API

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  ## Server callbacks

  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      KV.BucketSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
