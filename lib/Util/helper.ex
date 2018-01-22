defmodule Util.Helper do

  def http_query_string(params) do
    params
    |> Map.to_list
    |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
    |> Enum.join("&")
  end

  def nonce() do
    :os.system_time(:millisecond)
  end

  def map_keys_to_string(map) do
    k = Map.keys(map) |> Enum.map(&(Atom.to_string(&1)))
    v = Map.values(map)
    Enum.zip(k,v) |> Enum.into(%{})
  end

end
