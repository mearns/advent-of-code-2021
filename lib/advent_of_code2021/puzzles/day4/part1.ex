defmodule AdventOfCode2021.Puzzles.Day4.Part1 do

  alias AdventOfCode2021.Puzzles.Day4.BingoLoader
  alias AdventOfCode2021.Puzzles.Day4.Helpers

  @spec main :: pos_integer
  def main() do
    BingoLoader.load_from_stream(IO.stream())
    |> (fn ({ inputs, games }) -> Helpers.play_to_win(games, inputs) end).()
  end

end
