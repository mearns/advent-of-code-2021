defmodule AdventOfCode2021.Puzzles.Day15.Helpers do

  alias AdventOfCode2021.Puzzles.Day15.Grids

  def min_cost(_a = nil, b), do: b
  def min_cost(a, b), do: min(a, b)

  def load(what_to_use) do
    what_to_use
    |> load_lines_of_text()
    |> Grids.load_from_text_lines()
  end

  defp load_lines_of_text(:use_real) do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
  end

  defp load_lines_of_text(:use_sample), do: [
    "1163751742",
    "1381373672",
    "2136511328",
    "3694931569",
    "7463417111",
    "1319128137",
    "1359912421",
    "3125421639",
    "1293138521",
    "2311944581"
  ]

end
