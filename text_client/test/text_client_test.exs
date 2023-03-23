defmodule TextClientTest do
  use ExUnit.Case
  doctest TextClient

  test "a won game is terminated" do
    assert TextClient.start == :ok
  end

  test "a lost game is terminated" do
    assert TextClient.start == :ok
  end
end
