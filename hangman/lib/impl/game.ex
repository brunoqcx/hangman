defmodule Hangman.Impl.Game do
  defdelegate word, to: Dictionary
  alias Hangman.Type

  @type t :: %Hangman.Impl.Game{
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t)
   }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    word
    |> new_game
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
    letters: word |> String.codepoints
   }
  end

  @spec make_move(t, String.t) :: { t, Type.tally }
  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: masked_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  defp return_with_tally(game) do
    { game, tally(game) }
  end

  def accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end

  def accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    updated_state = success_guess_state(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: updated_state }
  end

  defp score_guess(game = %{ turns_left: 1 }, _bad_guess) do
    %{ game | game_state: :lost, turns_left: game.turns_left - 1 }
  end

  defp score_guess(game, _bad_guess) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  defp success_guess_state(true), do: :won
  defp success_guess_state(_false), do: :good_guess

  defp masked_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> mask_letter(letter) end)
  end

  defp mask_letter(true, letter), do: letter
  defp mask_letter(_false, _letter), do: "_"
end
