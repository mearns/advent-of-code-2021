
defmodule AdventOfCode2021.Util.BinaryNumbers do
  use Bitwise

  def binary_to_decimal(bits), do: left_shift_in(0, bits)

  defp left_shift_in(value, [ 0 ]), do: value <<< 1
  defp left_shift_in(value, [ 1 ]), do: (value <<< 1) ||| 1
  defp left_shift_in(value, [ bit | other_bits ]), do: value |> left_shift_in([ bit ]) |> left_shift_in(other_bits)

end
