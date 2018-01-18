defmodule Acx do
  @endpoint "https://acx.io:443/api/v2/"

  def ticker(pair) do
    get("tickers/#{pair}.json")
  end

  def ticker() do
    ticker("btcaud")
  end

  defp get(uri) do
    "#{@endpoint}/#{uri}"
    |> HTTPoison.get
    |> process_response
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: 200}}) do
    {:ok, body |> Poison.decode}
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: _}}) do
    {:eror, {:error, :request_error, body}}
  end

  defp process_response({:error, message}) do
    {:error, {:error, :http_error, message}}
  end
end
