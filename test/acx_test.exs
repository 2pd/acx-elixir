defmodule AcxTest do
  use ExUnit.Case
  doctest Acx

  test "genenrate propose" do
    IO.inspect Application.get_env(:acx, :url)
  end

  # test "should return all ticker values for default pair" do
    # {:ok, ticker} = Acx.ticker()
    # ticker
    # |> Map.from_struct
    # |> Enum.map(fn {_, value} -> assert value != nil end)
  # end

  # test "should return all ticker values for eth pair" do
    # {:ok, ticker} = Acx.ticker("ethaud")
    # ticker
    # |> Map.from_struct
    # |> Enum.map(fn {_, value} -> assert value != nil end)
  # end

  # test "should return only 5 asks and 6 bids in orderbook" do
    # {:ok, orderbook} = Acx.orderbook("btcaud", {5,6})
    # assert length(orderbook["asks"]) == 5
    # assert length(orderbook["bids"]) == 6
  # end

  # test "should return 5 asks and bids in depth" do
    # {:ok, depth} = Acx.depth("btcaud", 5)
    # assert length(depth["asks"]) == 5
    # assert length(depth["bids"]) == 5
  # end


end
