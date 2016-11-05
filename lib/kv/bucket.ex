defmodule KV.Bucket do
  @doc """
  Starts a new bucket
  """

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end
end
