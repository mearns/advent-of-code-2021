
defmodule AdventOfCode2021.Puzzles.Day14.Helpers do

  def score(polymer) do
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


  def load(what_to_use) do
    what_to_use
    |> load_lines_of_text()
    |> Enum.to_list()
    |> then(fn ([template, _blankline = "" | rules ]) -> {
      template |> String.graphemes(),
      rules |> build_rule_map()
    } end )
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
