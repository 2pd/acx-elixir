defmodule Acx do
  @endpoint Application.get_env(:acx, :url)

  def depth(market \\ "btcaud", limit \\ 300) do
    public("depth.json?market=#{market}&limit=#{limit}")
  end

  def ticker(pair) do
    {:ok, ticker} = public("tickers/#{pair}.json")
    new_ticker = %Acx.Ticker{}
                 |> Map.put(:timestamp, ticker["at"])
                 |> Map.put(:buy, ticker["ticker"]["buy"])
                 |> Map.put(:sell, ticker["ticker"]["sell"])
                 |> Map.put(:low, ticker["ticker"]["low"])
                 |> Map.put(:high, ticker["ticker"]["high"])
                 |> Map.put(:last, ticker["ticker"]["last"])
                 |> Map.put(:volume, ticker["ticker"]["vol"])
    {:ok, new_ticker}
  end

  def ticker() do
    ticker("btcaud")
  end

  def markets() do
    public("markets.json")
  end

  def timestamp() do
    public("timestamp.json")
  end

  def orderbook(market, {asks_limit, bids_limit}) do

    if asks_limit != nil and bids_limit != nil do
        public("order_book.json?market=#{market}&asks_limit=#{asks_limit}&bids_limit=#{bids_limit}")
    else
        public("order_book.json?market=#{market}")
    end
  end

  def orderbook(market \\ "btcaud") do
    orderbook(market, {20, 20})
  end

  def private(uri, params) do
    arg_string = params
                 |> Map.to_list()
                 |> Enum.map( fn x -> Tuple.to_list(x) |> Enum.join("=") end)
                 |> Enum.join("&")
  end

  def signature(method, params) do
    params = %{params | "access_key" => get_access_key()}
    query_string = Util.Helper.http_query_string(params)

    string_to_encrypt = "GET|/api/v2/#{method}"

  end

  defp public(uri) do
    @endpoint <> uri
    |> HTTPoison.get
    |> process_response
  end

  defp get_access_key() do
    Application.get_env(:acx, :access_key)
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: 200}}) do
    body |> Poison.decode
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: _}}) do
    {:eror, {:error, :request_error, body}}
  end

  defp process_response({:error, message}) do
    {:error, {:error, :http_error, message}}
  end
end
