defmodule AcxTest do
  use ExUnit.Case
  doctest Acx


  test "send default ticker should query btcaud pair" do
    {:ok, ticker } = Acx.ticker()
  end

end
