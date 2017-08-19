defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for 'name' stored in 'server'
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end
  def lookup_all(server) do
    GenServer.call(server, {:lookup_all})
  end

  @doc """
  Ensures there is a bucket called 'name' on 'server'
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server callbacks

  def init(:ok) do
    names =  %{}
    refs =  %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state ) do
    {:reply, Map.fetch(names, name), state}
  end

  def handle_call({:lookup_all}, _from, {names, _} = state ) do
    {:reply, state, state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, pid} = KV.BucketSupervisor.start_bucket()
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

end
