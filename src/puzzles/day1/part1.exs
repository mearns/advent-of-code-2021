defmodule Puzzle do

  defp parseDecimal!(string) do
    { result, remainder } = string |> Integer.parse(10)
    case remainder do
     "" -> result
      _ -> raise(RuntimeError, message: "Invalid decimal value: #{string}")
    end
  end

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
    |> Enum.map(&parseDecimal!/1)
    |> Enum.reduce(init(), &apply_depth_reading/2)
    increase_count
  end

end

Puzzle.main() |> IO.puts()
