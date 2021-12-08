defmodule AdventOfCode2021.Puzzles.Day5.Part1 do

  alias AdventOfCode2021.Puzzles.Day5.Line

  @spec main :: pos_integer
  def main() do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&Line.init/1)
    |> Stream.filter(&Line.is_horizontal_or_vertical/1)
    |> Enum.reduce(%{}, &Line.add_line_to_map/2)
    |> Map.values()
    |> Enum.filter(&(&1 >= 2))
    |> Enum.count()
  end

end
