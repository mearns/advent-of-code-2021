defmodule AdventOfCode2021.Puzzles.Day6.LanternFishTest do
  use ExUnit.Case

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day6.LanternFish

  test "load_from_text" do
    fish = LanternFish.load_from_text("3,4,3,1,2")
    assert fish == [3, 4, 3, 1, 2]
  end

  test "age_one_day without new fish" do
    fish = [3, 4, 3, 1, 2] |> LanternFish.age_one_day()
    assert fish == [2, 3, 2, 0, 1]
  end

  test "age_one_day with new fish" do
    fish = [2, 3, 2, 0, 1] |> LanternFish.age_one_day()
    assert fish == [1, 2, 1, 6, 8, 0]
  end

  test "age_days" do
    fish = [3, 4, 3, 1, 2] |> LanternFish.age_days(18)
    assert length(fish) == 26
  end

end
