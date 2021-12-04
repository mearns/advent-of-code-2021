defmodule AdventOfCode2021.Puzzles.Day3.Part2 do

  alias AdventOfCode2021.Util

  defp add_row_to_tree([ ], nil), do: :leaf

  defp add_row_to_tree(bits, nil) do
    bits |> add_row_to_tree(init_tree())
  end

  defp add_row_to_tree([ "0" | bits ], { weight, branch0, branch1 }) do
    {
      weight + 1,
      bits |> add_row_to_tree(branch0),
      branch1
    }
  end

  defp add_row_to_tree([ "1" | bits ], { weight, branch0, branch1 }) do
    {
      weight + 1,
      branch0,
      bits |> add_row_to_tree(branch1),
    }
  end

  defp init_tree(), do: { 0, nil, nil }

  defp stream_to_tree(row_stream) do
    row_stream |> Enum.reduce(init_tree(), &add_row_to_tree/2)
  end

  defp walk_tree(tree, selector), do: walk_tree([], tree, selector)

  defp walk_tree(path, :leaf, _selector), do: path

  defp walk_tree(rev_path, { _weight, branch0, branch1 }, selector) do
    case ({ branch0, branch1 } |> selector.()) do
      :first -> :zero
      :second -> :one
    end
    |> descend_tree(rev_path, { branch0, branch1 }, selector)
  end

  defp descend_tree(:zero, rev_path, { branch0, _branch1 }, selector) do
    walk_tree([0 | rev_path], branch0, selector)
  end

  defp descend_tree(:one, rev_path, { _branch0, branch1 }, selector) do
    walk_tree([1 | rev_path], branch1, selector)
  end

  defp o2_generator_rating(tree) do
    tree |> apply_filter(&o2_selector/1)
  end

  defp co2_scrubber_rating(tree) do
    tree |> apply_filter(&co2_selector/1)
  end

  defp apply_filter(tree, selector) do
    tree
    |> walk_tree(selector)
    |> (fn (rev_path) ->
        rev_path |> inspect() |> IO.puts()
        rev_path
    end).()
    |> Util.BinaryNumbers.rev_binary_to_decimal()
  end

  defp o2_selector({_first, nil}),  do: :first
  defp o2_selector({nil, _second}),  do: :second
  defp o2_selector({:leaf, :leaf}),  do: :second
  defp o2_selector({{ zweight, _, _ }, {oweight, _, _}}) when zweight > oweight, do: :first
  defp o2_selector({{ _, _, _ }, { _, _, _ }}), do: :second

  defp co2_selector({_first, nil}),  do: :first
  defp co2_selector({nil, _second}),  do: :second
  defp co2_selector({:leaf, :leaf}),  do: :first
  defp co2_selector({{ zweight, _, _ }, {oweight, _, _}}) when zweight > oweight, do: :second
  defp co2_selector({{ _, _, _ }, { _, _, _ }}), do: :first

  defp print_tree(tree) do
    tree |> print_tree("", "")
  end

  defp print_tree(nil, indent, path) do
    "#{indent}(W0)<'#{path}'>" |> IO.puts()
  end

  defp print_tree(:leaf, indent, path) do
    "#{indent}(W1)'#{path}.'" |> IO.puts()
  end

  defp print_tree(tree = { weight, branch0, branch1 }, indent, path) do
    "#{indent}(W#{weight}) '#{path}'" |> IO.puts()
    next_indent = indent <> "|   "
    branch0 |> print_tree(next_indent, path <> "0")
    branch1 |> print_tree(next_indent, path <> "1")
    tree
  end

  defp get_input_stream(:real), do: IO.stream() |> Stream.map(&String.trim_trailing/1)
  defp get_input_stream(:fake), do: [
    "00100",
    "11110",
    "10110",
    "10111",
    "10101",
    "01111",
    "00111",
    "11100",
    "10000",
    "11001",
    "00010",
    "01010",
  ]

  defp two_pipe(subj, f1, f2) do
    {
      subj |> f1.(),
      subj |> f2.(),
    }
  end

  defp multiply({ first, second }) do
    { first, second } |> inspect() |> IO.puts()
    first * second
  end

  def main() do
    :real
      |> get_input_stream()
      |> Stream.map(&String.graphemes/1)
      |> stream_to_tree()
      # |> print_tree()
      |> two_pipe(&o2_generator_rating/1, &co2_scrubber_rating/1)
      |> multiply()
  end

end
