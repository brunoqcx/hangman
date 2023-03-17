defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dictionary.hello()
      :world

  """

  def word do
    File.read!("assets/words.txt")
    |> String.split(~r/\n/, trim: true)
    |> Enum.random
  end

  def exec_word do
    "had we but world enough, and time"
  end

  def exec1 do
    exec_word()
    |> String.split(~r/,/)
  end

  def exec2 do
    exec_word()
    |> String.codepoints
  end

  def exec4 do
    exec_word()
    |> String.reverse
  end

  def exec5 do
    exec_word()
    |> String.myers_difference("had we but bacon enough, and treacle")
  end

  def exec6(str) do
    str =~ ~r/a.c/
  end

  def exec7(str) do
    Regex.replace(~r/cat/, str, "dog", global: false)
  end

  def exec8({ a, b }) do
    { b, a }
  end

  def exec9(a, a) do
    true
  end

  def exec10([]), do: []
  def exec10([h|t]), do: [Integer.pow(h, 2) | exec10(t)]
end
