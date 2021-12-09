defmodule AdventOfCode2021.Puzzles.Day6.Part1 do
  alias AdventOfCode2021.Puzzles.Day6.LanternFish

  @spec main() :: pos_integer
  def main() do
    IO.stream()
    |> Stream.take(1)
    |> Enum.map(&String.trim_trailing/1)
    |> List.first()
    |> LanternFish.load_from_text()
    |> (&(&1 |> LanternFish.age_days(&2))).(80)
    |> (&(&1 |> length)).()
  end
end
