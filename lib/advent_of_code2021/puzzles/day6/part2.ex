defmodule AdventOfCode2021.Puzzles.Day6.Part2 do
  alias AdventOfCode2021.Puzzles.Day6.LanternFish2

  @spec main() :: pos_integer
  def main() do
    IO.stream()
    |> Stream.take(1)
    |> Enum.map(&String.trim_trailing/1)
    |> List.first()
    |> LanternFish2.load_from_text()
    |> (&(&1 |> LanternFish2.age_days(&2))).(256)
    |> LanternFish2.get_total_count()
  end
end
