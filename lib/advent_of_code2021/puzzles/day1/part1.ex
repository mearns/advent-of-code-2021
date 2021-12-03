defmodule AdventOfCode2021.Puzzles.Day1.Part1 do

  alias AdventOfCode2021.Util

  defp init() do
    %{ prev: nil, increase_count: nil }
  end

  defp apply_depth_reading(depth, %{ prev: nil, increase_count: nil }),
    do: %{ prev: depth, increase_count: 0 }

  defp apply_depth_reading(depth, %{ prev: prev, increase_count: increase_count }) when depth > prev,
    do: %{ prev: depth, increase_count: increase_count + 1 }

  defp apply_depth_reading(depth, %{ prev: prev, increase_count: increase_count }) when depth <= prev,
    do: %{ prev: depth, increase_count: increase_count }

  def main() do
    %{ increase_count: increase_count } = IO.stream()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&Util.Parse.parse_decimal!/1)
    |> Enum.reduce(init(), &apply_depth_reading/2)
    increase_count
  end

end
