defmodule AdventOfCode2021.Puzzles.Day4.Helpers do
  alias AdventOfCode2021.Puzzles.Day4.Bingo

  @spec play_to_win([ Bingo.bing_games ], [ Bingo.bingo_value ]) :: pos_integer() | nil

  def play_to_win(_games, [ ]), do: nil

  def play_to_win(games, [ value | values ]) do
    updated_games = games |> Bingo.mark_in_all_games(value)
    case updated_games |> Bingo.find_winner() do
      nil -> play_to_win(updated_games, values)
      winner -> Bingo.get_score(winner, value)
    end
  end
end
