defmodule AdventOfCode2021.Puzzles.Day16.PathSetTest do
  use ExUnit.Case

  alias AdventOfCode2021.Puzzles.Day16.PathSet
  alias AdventOfCode2021.Puzzles.Day16.GridPath

  test "GridPath" do
    path = GridPath.init({ 5, 5 })
    assert path |> GridPath.get_destination() == {5, 5}
    assert path |> GridPath.complete?() == false
    assert path |> GridPath.get_path() == [{ 0, 0}]
    assert path |> GridPath.get_best_case_cost() == 5 + 5
    assert path |> GridPath.get_worst_case_cost() == 9 * (5 + 5)
    assert path |> GridPath.get_concrete_cost() == 0
  end

  test "GridPath extend" do
    { :ok, path } = GridPath.init({ 5, 5 }) |> GridPath.extend({ 1, 1 }, 3)
    assert path |> GridPath.get_destination() == {5, 5}
    assert path |> GridPath.complete?() == false
    assert path |> GridPath.get_path() == [{ 0, 0}, {1, 1}]
    assert path |> GridPath.get_best_case_cost() == 3 + (4 + 4)
    assert path |> GridPath.get_worst_case_cost() == 3 + 9 * (4 + 4)
    assert path |> GridPath.get_concrete_cost() == 3
  end

  test "GridPath extend twice" do
    { :ok, path } = GridPath.init({ 5, 5 }) |> GridPath.extend({ 1, 1 }, 3) |> GridPath.extend({ 1, 2 }, 5)
    assert path |> GridPath.get_destination() == {5, 5}
    assert path |> GridPath.complete?() == false
    assert path |> GridPath.get_path() == [{ 0, 0}, {1, 1}, { 1, 2 }]
    assert path |> GridPath.get_concrete_cost() == 8
    assert path |> GridPath.get_best_case_cost() == 8 + (4 + 3)
    assert path |> GridPath.get_worst_case_cost() == 8 + 9 * (4 + 3)
  end

  test "Completing a grid path" do
    { :ok, path } = GridPath.init({5, 5}) |> GridPath.extend({ 5, 5 }, 7)
    assert path |> GridPath.get_destination() == {5, 5}
    assert path |> GridPath.complete?() == true
    assert path |> GridPath.get_path() == [{ 0, 0}, {5, 5}]
    assert path |> GridPath.get_concrete_cost() == 7
    assert path |> GridPath.get_best_case_cost() == 7
    assert path |> GridPath.get_worst_case_cost() == 7
  end

  test "Initializing a complete grid path" do
    path = GridPath.init({ 3, 4 }, {3, 4})
    assert path |> GridPath.get_destination() == {3, 4}
    assert path |> GridPath.complete?() == true
    assert path |> GridPath.get_path() == [{ 3, 4}]
    assert path |> GridPath.get_concrete_cost() == 0
    assert path |> GridPath.get_best_case_cost() == 0
    assert path |> GridPath.get_worst_case_cost() == 0
  end

end
