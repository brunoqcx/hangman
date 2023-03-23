defmodule TextClient do

  defdelegate start(), to: TextClient.Impl.Player
end
