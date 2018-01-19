defmodule Util.Helper do

  def http_query_string(params) do
    params
    |> Map.to_list
    |> Enum.map(fn x -> Tuple.to_list(x) |> Enum.join("=") end)
    |> Enum.join("&")
  end


end
