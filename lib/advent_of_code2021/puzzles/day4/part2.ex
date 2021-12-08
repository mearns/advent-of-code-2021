defmodule AdventOfCode2021.Puzzles.Day4.Part2 do

  alias AdventOfCode2021.Puzzles.Day4.Bingo
  alias AdventOfCode2021.Puzzles.Day4.Helpers
  alias AdventOfCode2021.Puzzles.Day4.BingoLoader

  @spec main :: pos_integer
  def main() do
    { inputs, games } = BingoLoader.load_from_stream(IO.stream())
    play_to_lose(games, inputs)
  end

  @spec play_to_lose([ Bingo.bing_games ], [ Bingo.bingo_value ]) :: pos_integer() | nil

  defp play_to_lose([], _values) do
    raise "Ran out of games, looks like more than one game finished at the same time"
  end

  defp play_to_lose([ _game | _games ], []) do
    raise "Ran out of input with at least one non-winning game left"
  end

  defp play_to_lose([ final_game ], values) do
    Helpers.play_to_win([ final_game ], values)
  end

  defp play_to_lose(games, [ value | values ]) do
    games
    |> Bingo.mark_in_all_games(value)
    |> Enum.filter(&(!Bingo.wins?(&1)))
    |> play_to_lose(values)
  end
end
