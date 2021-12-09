defmodule AdventOfCode2021.Puzzles.Day6.LanternFish2 do

  alias AdventOfCode2021.Puzzles.Day6.LanternFish

  @age_range 0..8
  @typep age :: 0..8

  @type age_histogram :: %{ age => pos_integer }

  def load_from_text(text) do
    text
    |> LanternFish.load_from_text()
    |> Enum.reduce(init(), fn fish, map ->
      map |> Map.update(fish, 1, &(&1 + 1))
    end)
  end

  defp init() do
    @age_range |> Enum.reduce(%{}, &(&2 |> Map.put(&1, 0)))
  end

  def get_total_count(histogram) do
    histogram
    |> Enum.map(fn { _age, count } -> count end)
    |> Enum.sum()
  end

  def age_days(fish, 0), do: fish
  def age_days(fish, day_count), do: fish |> age_one_day() |> age_days(day_count - 1)

  @spec age_one_day(age_histogram) :: age_histogram()

  def age_one_day(histogram) do
    @age_range
    |> Enum.reduce(init(), fn age, map ->
      histogram
      |> Map.get(age, 0)
      |> age_cohort_one_day(age, map)
    end)
  end

  defp age_cohort_one_day(count, cohort_age, map) when cohort_age == 0, do: %{ map | 6 => count, 8 => count }
  defp age_cohort_one_day(count, cohort_age, map), do: map |> Map.update(cohort_age - 1, count, &(&1 + count))

end
