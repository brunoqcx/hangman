defmodule ImplGameTest do
  use ExUnit.Case
  doctest Hangman
  alias Hangman.Impl.Game

  test "new game returns a game" do
    game = Game.new_game("abc")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["a", "b", "c"]
  end

  test "a finalized game is returned with no changes" do
    for state <- [:won, :lost] do
      game = Game.new_game("abc") |> Map.put(:game_state, state)

      { changed_game, _tally } = Game.make_move(game, "x")

      assert game == changed_game
    end
  end

  test "a duplicated letter is reported" do
    game = Game.new_game("abc")

    { game, _tally } = Game.make_move(game, "a")

    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "a")

    assert game.game_state == :already_used
  end

  test "ther letters are recorded" do
    game = Game.new_game("abc")

    { game, _tally } = Game.make_move(game, "a")
    { game, _tally } = Game.make_move(game, "a")
    { game, _tally } = Game.make_move(game, "b")

    assert MapSet.equal?(game.used, MapSet.new(["a", "b"]))
  end

  test "a good guess is reconigzed" do
    game = Game.new_game("abc")

    { game, _tally } = Game.make_move(game, "a")

    assert game.game_state == :good_guess
  end

  test "a bad guess is reconigzed" do
    game = Game.new_game("abc")

    { game, _tally } = Game.make_move(game, "x")

    assert game.game_state == :bad_guess
  end

  test "the word is partially revelead with a good guess" do
    game = Game.new_game("abc")

    { _game, tally } = Game.make_move(game, "a")

    assert tally.letters == ["a", "_", "_"]
  end
end
