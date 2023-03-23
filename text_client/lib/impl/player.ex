defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start() :: :ok
  def start() do
    IO.puts("welcome to hangman!")
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    run_game({ game, tally })
  end

  @spec run_game(state) :: :ok
  defp run_game({ _game, _tally = %{ game_state: :won }}) do
    IO.puts "Congrats you won!!!"
  end

  defp run_game({ game, tally = %{ game_state: :lost }})  do
    IO.puts "You lost :(  , the word was #{Enum.join(game.letters)}"
  end

  defp run_game({ game, tally }) do
    IO.puts feedback_for(tally)
    IO.puts score_board(tally)

    { updated_game, updated_tally } = Hangman.make_move(game, new_letter_guess())
    run_game({ updated_game, updated_tally })
  end

  @spec feedback_for(tally) :: string
  defp feedback_for(tally = %{ game_state: :initializing }) do
    "The word has #{tally.letters |> length } letters, make a guess"
  end

  defp feedback_for(tally = %{ game_state: :good_guess }), do: "good guess!"
  defp feedback_for(tally = %{ game_state: :bad_guess }), do: "thats wrong"
  defp feedback_for(tally = %{ game_state: :already_used }), do: "that letter was already used"
  defp score_board(tally) do
    IO.puts [
      "the current word is #{tally.letters |> Enum.join(" ")}\n",
      "you already used #{tally.used |> Enum.join(",")}\n",
      "you have #{tally.turns_left} turns left\n",
      "\n\n\n"
    ]
  end

  def new_letter_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
