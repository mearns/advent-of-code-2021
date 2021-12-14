defmodule AdventOfCode2021.Puzzles.Day14.Part2 do

  alias AdventOfCode2021.Util.Debug
  alias AdventOfCode2021.Puzzles.Day14.Helpers

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    what_to_use
    |> Helpers.load()
    |> then(fn { template, rule_map } -> template |> init_template() |> apply_rules_times(40, rule_map) end )
    |> pair_counts_to_component_counts()
    |> Helpers.score_frequency_map()
  end

  defp pair_counts_to_component_counts(pair_counts) do
    pair_counts |> Enum.reduce(%{}, fn ({ pair, count }, component_counts) ->
      pair
      |> String.split("")
      |> then(fn ([_, first, second, _]) -> [ first, second ] end)
      |> Enum.reduce(component_counts, fn (component, map) ->
        map |> Map.update(component, count, &(&1 + count ))
      end)
    end)
    |> Enum.reduce(%{}, fn ({ component, count }, map) ->
      map |> Map.put(component, div(count + 1, 2))
    end)
  end

  defp init_template([ _last ]), do: %{}

  defp init_template([ first, second | others ]) do
    [ second | others ]
    |> init_template()
    |> Map.update(first <> second, 1, &(&1+1))
  end

  def apply_rules_times(template, 0, _rule_map), do: template

  def apply_rules_times(template, times, rule_map) do
    template |> apply_rules(rule_map) |> apply_rules_times(times - 1, rule_map)
  end

  defp apply_rules(template_map, rule_map) do
    template_map
    |> Enum.reduce(%{}, fn ({ pair, count }, updated_map) ->
      rule_map
      |> Map.get(pair)
      |> then(fn insert ->
        pair
        |> String.split("")
        |> then(fn [_, first, second, _] -> [ first <> insert, insert <> second ] end)
        |> Enum.reduce(updated_map, fn (new_pair, updated_map) ->
          updated_map |> Map.update(new_pair, count, &(&1 + count))
        end)
      end)
    end)
  end


end
