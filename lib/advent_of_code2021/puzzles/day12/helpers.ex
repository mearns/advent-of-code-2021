
defmodule AdventOfCode2021.Puzzles.Day12.Helpers do

  alias AdventOfCode2021.Puzzles.Day12.Caves

  def load(what_to_use) do
    what_to_use
    |> load_lines_of_text()
    |> parse_lines()
  end

  defp parse_lines(lines) do
    lines
    |> Enum.reduce(Caves.init(), &add_line/2)
  end

  defp add_line(line, caves = %Caves{}) do
    line
    |> String.split("-")
    |> then(fn [a, b] -> caves |> Caves.add_pair({ a, b }) end)
  end

  defp load_lines_of_text(:use_real) do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
  end

  defp load_lines_of_text(:use_sample), do: [
    "dc-end",
    "HN-start",
    "start-kj",
    "dc-start",
    "dc-HN",
    "LN-dc",
    "HN-end",
    "kj-sa",
    "kj-HN",
    "kj-dc",
  ]

end
