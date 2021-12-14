defmodule AdventOfCode2021.Puzzles.Day14.Part1 do

  alias AdventOfCode2021.Util.Debug

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    load_lines_of_text(what_to_use)
    |> Enum.to_list()
    |> then(fn ([template, _blankline = "" | rules ]) -> {
      template |> String.graphemes(),
      rules |> build_rule_map()
    } end )
    |> then(fn { template, rule_map } -> template |> apply_rules_times(10, rule_map) end )
    |> score()
  end

  defp score(polymer) do
    count_polymer(polymer)
    |> get_most_and_least_common()
    |> then(fn ({{ min, _minkey }, { max, _maxkey }}) -> max - min end )
  end

  defp get_most_and_least_common(map) do
    map
    |> Enum.reduce({ { nil, nil }, { nil, nil } }, fn ({ key, count }, { { min, minkey }, { max, maxkey } }) ->
      {
        cond do
          min == nil or count < min -> { count, key }
          true -> { min, minkey }
        end,
        cond do
          max == nil or count > max -> { count, key }
          true -> { max, maxkey }
        end
      }
    end)
  end

  defp count_polymer([ ]), do: %{}

  defp count_polymer([ first | others ]) do
    others
    |> count_polymer()
    |> Map.update(first, 1, &(&1 + 1))
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

  defp build_rule_map([ ]), do: %{}
  defp build_rule_map([ rule | rules ]) do
    rule
    |> parse_rule()
    |> then(fn { pair, insert } ->
      rules
      |> build_rule_map()
      |> Map.put_new(pair, insert)
    end)
  end

  defp parse_rule(rule) do
    ~r/^(.)(.) -> (.)$/
    |> Regex.run(rule)
    |> then( fn [_, first, second, insert] -> { first <> second, insert } end )
  end

  defp load_lines_of_text(:use_real) do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
  end

  defp load_lines_of_text(:use_sample), do: [
    "NNCB",
    "",
    "CH -> B",
    "HH -> N",
    "CB -> H",
    "NH -> C",
    "HB -> C",
    "HC -> B",
    "HN -> C",
    "NN -> C",
    "BH -> H",
    "NC -> B",
    "NB -> B",
    "BN -> B",
    "BB -> N",
    "BC -> B",
    "CC -> N",
    "CN -> C",
  ]


end
