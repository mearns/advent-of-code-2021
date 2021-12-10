defmodule AdventOfCode2021.Puzzles.Day4.BingoTest do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Util.BinaryNumbers

  test "to_alphabetical" do
    assert "A" = BinaryNumbers.to_alphabetical(0)
    assert "Z" = BinaryNumbers.to_alphabetical(25)
    assert "AA" = BinaryNumbers.to_alphabetical(26)
    assert "AB" = BinaryNumbers.to_alphabetical(27)
    assert "BA" = BinaryNumbers.to_alphabetical(52)
    assert "CA" = BinaryNumbers.to_alphabetical(3 * 26)
    assert "ZA" = BinaryNumbers.to_alphabetical(26 * 26)
    assert "ZZ" = BinaryNumbers.to_alphabetical(26 * 26 + 25)
    assert "AAA" = BinaryNumbers.to_alphabetical(26 * 26 + 26)
  end
end
