defmodule HelperTest do
  use ExUnit.Case

  test "http query test" do
    string = Util.Helper.http_query_string(%{"foo" => "bar", "ping" => "pong"})
    assert string == "foo=bar&ping=pong"
  end

end
