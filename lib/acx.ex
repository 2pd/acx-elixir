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

  def balance()  do
    private("members/me.json", "GET", %{})
  end


  @doc """
  Get open orders https://acx.io/documents/api_v2#!/orders/GET_version_orders_format

  // get open orders from btcaud pair with all default settings.
  orders()

  // get orders with all supported format
  orders("btcaud", %{"limit" => 10, "state" => "open", "page" => 3, "order_by" => "asc"}

  """
  def get_orders(market \\ "btcaud", params \\ %{}) do
    private("orders.json", "GET", Map.put(params, "market", market))
  end

  def buy(volume, market) do
    post_order(market, %Acx.Order{volume: volume, side: "buy"})
  end

  def buy(volume, price, market) do
    post_order(market, %Acx.Order{volume: volume, price: price, side: "buy"})
  end

  def post_order(market, params \\ %Acx.Order{}) do
    params = params
             |> Map.from_struct
             |> Enum.filter(fn{_k, v} -> v !=nil end)
             |> Enum.into(%{})
             |> Util.Helper.map_keys_to_string
             |> Map.put("market", market)
    private("orders.json", "POST", params)
  end

  def cancel(id) do
    private("order/delete.json", "POST", %{"id" => id})
  end

  def get_order(id) do
    private("order.json", "GET", %{"id" => id})
  end

  def clear(side) do
    private("orders/clear.json","POST", %{"side" => side})
  end

  def clear() do
    private("orders/clear.json", "POST", %{})
  end

  defp private(uri, "GET", params) do
    @endpoint <> uri <> "?" <> params_to_request(params) <> "&signature=" <> signature(uri, "GET", params)
    |> HTTPoison.get([], hackney: [:insecure])
    |> process_response
  end

  defp private(uri, "POST", params) do
    body = params_to_request(params) <> "&signature=" <> signature(uri, "POST", params)
    IO.puts body
    @endpoint <> uri
      # |> HTTPoison.post({:form, body}, %{"Content-Type"=> "application/x-www-form-urlencoded"}, hackney: [:insecure])
      |> HTTPoison.post!(body, [{"Content-Type", "application/x-www-form-urlencoded"}], [ ssl: [{:versions, [:'tlsv1.2']}]])
      |> process_response
  end

  # defp private(uri), do: private(uri, %{})

  defp signature(method, http_method, params) do
    query_string = params_to_request(params)
    string_to_encrypt = "#{http_method}|/api/v2/#{method}|#{query_string}"
    :crypto.hmac(:sha256, get_secret_key(), string_to_encrypt)
      |> Base.encode16
      |> String.downcase
  end

  defp params_to_request(params) do
    params
    |> Map.put("access_key",  get_access_key())
    |> Map.put("tonce",  Util.Helper.nonce())
    |> Enum.sort() |> Map.new
    |> Util.Helper.http_query_string
  end

  defp public(uri) do
    @endpoint <> uri
    |> HTTPoison.get([], [ ssl: [{:versions, [:'tlsv1.2']}]])
    |> process_response
  end

  defp get_access_key() do
    Application.get_env(:acx, :access_key)
  end

  defp get_secret_key() do
    Application.get_env(:acx, :secrect_key)
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: 200}}) do
    body |> Poison.decode
  end

  defp process_response(%HTTPoison.Response{body: body, headers: _, request_url: _, status_code: 201}) do
    body |> Poison.decode
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: _, request_url: _, status_code: _}}) do
    {:eror, {:error, :api_error, body}}
  end

  defp process_response(%HTTPoison.Response{body: body, headers: _, request_url: _, status_code: _}) do
    {:error, {:error, :api_error, body}}
  end

  defp process_response({:error, message}) do
    {:error, {:error, :http_error, message}}
  end
end
