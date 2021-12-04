defmodule AdventOfCode2021.Puzzles.Day3.Helpers do
  defp init_bit_count(), do: { 0, 0 }
  defp init_bit_count(bit), do: init_bit_count() |> count_bit(bit)

  defp count_bit({ zeroes, ones }, "0"), do: { zeroes + 1, ones }
  defp count_bit({ zeroes, ones }, "1"), do: { zeroes, ones + 1 }

  def apply_row([], []), do: []
  def apply_row([], nil), do: []

  # Initial case, before we have any bit_counts (so, first row)
  def apply_row([ bit | other_bits ], nil) do
    [ init_bit_count(bit) | apply_row(other_bits, nil ) ]
  end

  def apply_row([ bit | other_bits ], [ bit_count | other_bit_counts ]) do
    [ bit_count |> count_bit(bit) | apply_row(other_bits, other_bit_counts) ]
  end


  def most_common_bits([ ]), do: []

  def most_common_bits([ { zeroes, ones } | other_bit_counts ])
    when ones > zeroes,
    do: [1 | most_common_bits(other_bit_counts)]

  def most_common_bits([ { _zeroes, _ones } | other_bit_counts ]),
    do: [0 | most_common_bits(other_bit_counts)]

  def least_common_bits([ ]), do: []

  def least_common_bits([ { zeroes, ones } | other_bit_counts ])
    when ones < zeroes,
    do: [1 | least_common_bits(other_bit_counts)]

  def least_common_bits([ { _zeroes, _ones } | other_bit_counts ]),
    do: [0 | least_common_bits(other_bit_counts)]

end
