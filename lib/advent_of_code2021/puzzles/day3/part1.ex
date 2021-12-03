defmodule AdventOfCode2021.Puzzles.Day3.Part1 do
  use Bitwise

  alias AdventOfCode2021.Util


  defp init_bit_count(), do: { 0, 0 }
  defp init_bit_count(bit), do: init_bit_count() |> count_bit(bit)

  defp count_bit({ zeroes, ones }, "0"), do: { zeroes + 1, ones }
  defp count_bit({ zeroes, ones }, "1"), do: { zeroes, ones + 1 }

  defp apply_row([], []), do: []
  defp apply_row([], nil), do: []

  # Initial case, before we have any bit_counts (so, first row)
  defp apply_row([ bit | other_bits ], nil) do
    [ init_bit_count(bit) | apply_row(other_bits, nil ) ]
  end

  defp apply_row([ bit | other_bits ], [ bit_count | other_bit_counts ]) do
    [ bit_count |> count_bit(bit) | apply_row(other_bits, other_bit_counts) ]
  end

  defp init(), do: nil

  defp most_common_bits([ ]), do: []

  defp most_common_bits([ { zeroes, ones } | other_bit_counts ])
    when ones > zeroes,
    do: [1 | most_common_bits(other_bit_counts)]

  defp most_common_bits([ { _zeroes, _ones } | other_bit_counts ]),
    do: [0 | most_common_bits(other_bit_counts)]


  defp least_common_bits([ ]), do: []

  defp least_common_bits([ { zeroes, ones } | other_bit_counts ])
    when ones < zeroes,
    do: [1 | least_common_bits(other_bit_counts)]

  defp least_common_bits([ { _zeroes, _ones } | other_bit_counts ]),
    do: [0 | least_common_bits(other_bit_counts)]

  defp binary_to_decimal(bits), do: left_shift_in(0, bits)

  defp left_shift_in(value, [ 0 ]), do: value <<< 1
  defp left_shift_in(value, [ 1 ]), do: (value <<< 1) ||| 1
  defp left_shift_in(value, [ bit | other_bits ]), do: value |> left_shift_in([ bit ]) |> left_shift_in(other_bits)

  defp calculate_γ(bit_counts) do
    bit_counts
    |> most_common_bits()
    |> binary_to_decimal()
  end

  defp calculate_ε(bit_counts) do
    bit_counts
    |> least_common_bits()
    |> binary_to_decimal()
  end

  defp calculate_power_consumption(%{ γ: γ, ε: ε }), do: γ * ε

  def main() do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.reduce(init(), &apply_row/2)
    |> (fn (bit_counts) ->
      %{ γ: calculate_γ(bit_counts), ε: calculate_ε(bit_counts) }
    end).()
    |> calculate_power_consumption()
  end

end
