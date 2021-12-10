defmodule AdventOfCode2021.Puzzles.Day8.Part1 do

  alias AdventOfCode2021.Util.Debug

  @spec main() :: pos_integer()
  def main() do
    load()
    |> Stream.map(&select_second/1)
    |> Stream.map(&map_to_known_digits/1)
    |> Stream.map(&filter_out_nil/1)
    |> Stream.map(&length/1)
    |> Enum.sum()
  end

  defp filter_out_nil(list), do: list |> Enum.filter(&not_nil/1)

  defp not_nil(nil), do: false
  defp not_nil(_), do: true

  defp map_to_known_digits([]), do: []
  defp map_to_known_digits([word | words]) do
    [ word |> map_word_to_known_digit() | words |> map_to_known_digits() ]
  end

  defp map_word_to_known_digit(word) do
    case word |> String.length() do
      2 -> 1
      4 -> 4
      3 -> 7
      7 -> 8
      _ -> nil
    end
  end

  defp select_second([_f, s]), do: s

  defp load() do
    IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" | ")
    |> Enum.map(&(&1 |> String.split(" ")))
  end
end
