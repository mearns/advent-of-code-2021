defmodule AdventOfCode2021.Puzzles.Day9.HelpersTest do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day9.Helpers

  test "low point in top-left corner" do
    res = [
      "13333",
      "33333",
      "33333",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in top-right corner" do
    res = [
      "33331",
      "33333",
      "33333",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in bottom-right corner" do
    res = [
      "33333",
      "33333",
      "33333",
      "33333",
      "33331"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in bottom-left corner" do
    res = [
      "33333",
      "33333",
      "33333",
      "33333",
      "13333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in top-center" do
    res = [
      "33133",
      "33333",
      "33333",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in middle-left" do
    res = [
      "33333",
      "33333",
      "13333",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in middle-second column" do
    res = [
      "33333",
      "33333",
      "31333",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()

    assert res == [ { 1, 2, 1 }]
  end

  test "low point in middle-center" do
    res = [
      "33333",
      "33333",
      "33133",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in middle-right" do
    res = [
      "33333",
      "33333",
      "33331",
      "33333",
      "33333"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in bottom-center" do
    res = [
      "33333",
      "33333",
      "33333",
      "33333",
      "33133"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1]
  end

  test "low point in bottom-second column" do
    res = [
      "33333",
      "33333",
      "33333",
      "34333",
      "43433"
    ] |> Helpers.load_from_text()

    assert res == [ { 3, 4, 1 }]
  end

  test "low point in four corners" do
    res = [
      "39992",
      "99999",
      "99999",
      "99999",
      "49991"
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1, 4, 2, 3]
  end

  test "low points in second row and second from end" do
    res = [
      "99999",
      "39992",
      "99999",
      "49991",
      "99999",
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [1, 4, 2, 3]
  end

  test "from real input" do
    res = [
      "92101349",
      "89215498",
      "78936987",
      "99987898",
    ] |> Helpers.load_from_text()
    |> Enum.map(fn { height, _line, _col } -> height end)

    assert res == [7, 7, 0]
  end

  test "line and column numbers" do
    res = [
      "92101349",
      "89215498",
      "78936987",
      "99987598",
    ] |> Helpers.load_from_text()

    assert res == [
      { 5, 3, 5 },
      { 7, 2, 7 },
      { 7, 2, 0 },
      { 0, 0, 3 },
    ]
  end


end
