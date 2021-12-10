
defmodule AdventOfCode2021.Util.BinaryNumbers do
  use Bitwise

  def rev_binary_to_decimal([ ]), do: 0
  def rev_binary_to_decimal([ lsb | bits ]) do
    ((bits |> rev_binary_to_decimal()) <<< 1) ||| lsb
  end

  def binary_to_decimal(bits), do: left_shift_in(0, bits)

  defp left_shift_in(value, [ 0 ]), do: value <<< 1
  defp left_shift_in(value, [ 1 ]), do: (value <<< 1) ||| 1
  defp left_shift_in(value, [ bit | other_bits ]), do: value |> left_shift_in([ bit ]) |> left_shift_in(other_bits)

  def to_alphabetical(value) do
    top = div(value, 26)
    bottom = rem(value, 26)
    cond do
      # Single digit value.
      top == 0 -> List.to_string([0x41 + value])

      # We're at the Most Sig Digit, so A = 1 ... Z = 26
      # But all lower digits are A = 0 ... Z = 25
      top <= 26 -> List.to_string([
        [0x40 + top],
        [0x41 + bottom]
      ])

      # Two or more digits, recurse
      true -> to_alphabetical(top) <> to_alphabetical(bottom)
    end
  end

end
