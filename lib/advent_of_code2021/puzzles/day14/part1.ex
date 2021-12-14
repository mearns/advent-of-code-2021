defmodule AdventOfCode2021.Puzzles.Day14.Part1 do

  alias AdventOfCode2021.Puzzles.Day14.Helpers

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    what_to_use
    |> Helpers.load()
    |> then(fn { template, rule_map } -> template |> apply_rules_times(10, rule_map) end )
    |> Helpers.score()
  end

  def apply_rules_times(template, 0, _rule_map), do: template

  def apply_rules_times(template, times, rule_map) do
    template |> apply_rules(rule_map) |> apply_rules_times(times - 1, rule_map)
  end

  defp apply_rules([ last ], _rule_map), do: [ last ]

  defp apply_rules([ first, second | others ], rule_map) do
    first <> second
    |> then(&(Map.get(rule_map, &1)))
    |> then(fn insert -> [first,  insert | ([second | others] |> apply_rules(rule_map))] end)
  end


end
