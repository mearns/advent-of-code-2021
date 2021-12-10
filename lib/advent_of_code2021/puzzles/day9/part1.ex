defmodule AdventOfCode2021.Puzzles.Day9.Part1 do

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Util.Parse
  alias AdventOfCode2021.Util.BinaryNumbers
  alias AdventOfCode2021.Puzzles.Day9.Helpers

  @spec main() :: pos_integer()
  def main() do
    load_lines_of_text(:real)
    |> Helpers.load_from_text()
    |> Enum.map(fn { height, linenum, column } ->
      { height, linenum + 1, BinaryNumbers.to_alphabetical(column) }
    end)
    |> Debug.tee()
    |> Enum.map(&Helpers.get_risk_level/1)
    |> Enum.sum()
  end

  defp load_lines_of_text(:real) do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
  end

  defp load_lines_of_text(:test), do: [
    "2199943210",
    "3987894921",
    "9856789892",
    "8767896789",
    "9899965678",
  ]


end
