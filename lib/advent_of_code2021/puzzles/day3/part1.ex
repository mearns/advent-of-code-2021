defmodule AdventOfCode2021.Puzzles.Day3.Part1 do

  alias AdventOfCode2021.Util
  alias AdventOfCode2021.Puzzles.Day3.Helpers

  defp init(), do: nil

  defp calculate_γ(bit_counts) do
    bit_counts
    |> Helpers.most_common_bits()
    |> Util.BinaryNumbers.binary_to_decimal()
  end

  defp calculate_ε(bit_counts) do
    bit_counts
    |> Helpers.least_common_bits()
    |> Util.BinaryNumbers.binary_to_decimal()
  end

  defp calculate_power_consumption(%{ γ: γ, ε: ε }), do: γ * ε

  def main() do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.reduce(init(), &Helpers.apply_row/2)
    |> (fn (bit_counts) ->
      %{ γ: calculate_γ(bit_counts), ε: calculate_ε(bit_counts) }
    end).()
    |> calculate_power_consumption()
  end

end
