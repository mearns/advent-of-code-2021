defmodule AdventOfCode2021.Puzzles.Day1.Part2 do

  alias AdventOfCode2021.Util

  defp init() do
    %{ window: [], increase_count: nil }
  end

  defp apply_depth_reading(depth, %{ window: [], increase_count: nil }),
    do: %{ window: [depth], increase_count: nil }

  defp apply_depth_reading(depth, %{ window: [a], increase_count: nil }),
    do: %{ window: [a, depth], increase_count: nil }

  defp apply_depth_reading(depth, %{ window: [a, b], increase_count: nil }),
    do: %{ window: [a, b, depth], increase_count: 0 }

  defp apply_depth_reading(depth, %{ window: [a, b, c], increase_count: increase_count })
    when (b + c + depth) > (a + b + c),
    do: %{ window: [b, c, depth], increase_count: increase_count + 1 }

  defp apply_depth_reading(depth, %{ window: [_a, b, c], increase_count: increase_count }),
    do: %{ window: [b, c, depth], increase_count: increase_count }

  def main() do
    %{ increase_count: increase_count } = IO.stream()
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(&Util.Parse.parse_decimal!/1)
    |> Enum.reduce(init(), &apply_depth_reading/2)
    increase_count
  end

end
