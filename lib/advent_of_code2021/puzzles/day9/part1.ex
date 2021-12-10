defmodule AdventOfCode2021.Puzzles.Day9.Part1 do

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Util.Parse
  alias AdventOfCode2021.Puzzles.Day9.Helpers

  @spec main() :: pos_integer()
  def main() do
    load(:real)
    |> Helpers.load_lines()
    |> Enum.map(&Helpers.get_risk_level/1)
    |> Enum.sum()
  end

  defp load(:real) do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> load_from_text()
  end

  defp load(:test), do: load_from_text([
    "2199943210",
    "3987894921",
    "9856789892",
    "8767896789",
    "9899965678",
  ])

  defp load_from_text(lines) do
    lines
    |> Stream.map(fn line -> line |> String.graphemes() |> Enum.map(&Parse.parse_decimal!/1) end)
  end

end
