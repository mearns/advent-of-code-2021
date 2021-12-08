defmodule AdventOfCode2021.Puzzles.Day4.BingoTest do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day4.Bingo

  test "greets the world" do
    game1 = Bingo.init([
      [10, 11, 12, 13, 14],
      [20, 21, 22, 23, 24],
      [31, 32, 33, 34, 35],
      [41, 42, 43, 44, 45],
      [99, 98, 97, 96, 95]
    ])

    values = [11, 12, 14, 21, 32, 42, 97, 99, 95, 96]
    :ok

  end
end
