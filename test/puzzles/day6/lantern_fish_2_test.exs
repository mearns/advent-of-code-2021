defmodule AdventOfCode2021.Puzzles.Day6.LanternFish2Test do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day6.LanternFish2

  test "load_from_text" do
    fish = LanternFish2.load_from_text("3,4,3,1,2")
    assert fish == %{ 0 => 0, 1 => 1, 2 => 1, 3 => 2, 4 => 1, 5 => 0, 6 => 0, 7 => 0, 8 => 0 }
  end

  test "age_one_day with no new fish" do
    fish = LanternFish2.load_from_text("3,4,3,1,2") |> LanternFish2.age_one_day()
    assert fish == %{ 0 => 1, 1 => 1, 2 => 2, 3 => 1, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0 }
  end

  test "age_one_day with new fish" do
    fish = LanternFish2.load_from_text("3,0,0,2,3") |> LanternFish2.age_one_day()
    assert fish == %{ 0 => 0, 1 => 1, 2 => 2, 3 => 0, 4 => 0, 5 => 0, 6 => 2, 7 => 0, 8 => 2 }
  end

end
