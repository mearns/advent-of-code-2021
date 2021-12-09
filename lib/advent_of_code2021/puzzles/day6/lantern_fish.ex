defmodule AdventOfCode2021.Puzzles.Day6.LanternFish do

  alias AdventOfCode2021.Util.Parse

  @typep fish :: 0..8

  def load_from_text(text) do
    text |> String.split(",") |> Enum.map(&Parse.parse_decimal!/1)
  end

  def age_days(fish, 0), do: fish
  def age_days(fish, day_count), do: fish |> age_one_day() |> age_days(day_count - 1)

  @spec age_one_day(list[fish]) :: list[fish]

  def age_one_day([ ]), do: []

  def age_one_day([ fish | fishes ]) when fish != 0 do
    [ fish - 1 | (fishes |> age_one_day()) ]
  end

  def age_one_day([ fish | fishes ]) when fish == 0 do
    [ 6, 8 | (fishes |> age_one_day()) ]
  end

end
