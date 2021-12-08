defmodule AdventOfCode2021.Puzzles.Day5.LineTest do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day5.Line

  test "init" do
    line1 = Line.init("0,9 -> 5,9")

    assert line1 == { 0, 9, 5, 9}
  end

  test "add horiztonal line to map" do
    map = Line.init("0,9 -> 5,9") |> Line.add_line_to_map(%{})
    assert %{"0x9" => 1, "1x9" => 1, "2x9" => 1, "3x9" => 1, "4x9" => 1, "5x9" => 1} == map
  end

  test "add vertical line to map" do
    map = Line.init("3,5 -> 3,8") |> Line.add_line_to_map(%{})
    assert %{"3x5" => 1, "3x6" => 1, "3x7" => 1, "3x8" => 1} == map
  end

  test "add horiztonal line and vertical line to map" do
    map1 = Line.init("0,6 -> 5,6") |> Line.add_line_to_map(%{})
    map = Line.init("3,5 -> 3,8") |> Line.add_line_to_map(map1)
    assert %{
      "0x6" => 1, "1x6" => 1, "2x6" => 1, "3x6" => 1, "4x6" => 1, "5x6" => 1,
      "3x5" => 1, "3x6" => 2, "3x7" => 1, "3x8" => 1
    } == map
  end

  test "horiztonal lines" do
    line1 = Line.init("0,9 -> 5,9")

    assert true == line1 |> Line.is_horizontal_or_vertical()
  end

  test "vertical lines" do
    line1 = Line.init("3,7 -> 3,9")

    assert true == line1 |> Line.is_horizontal_or_vertical()
  end

  test "diagonal lines" do
    line1 = Line.init("3,7 -> 4,9")

    assert false == (line1 |> Line.is_horizontal_or_vertical())
  end
end
