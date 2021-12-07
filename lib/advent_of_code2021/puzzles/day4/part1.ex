defmodule AdventOfCode2021.Puzzles.Day4.Part1 do

  alias AdventOfCode2021.Puzzles.Day4.Bingo
  alias AdventOfCode2021.Util.Parse
  alias AdventOfCode2021.Util.Debug

  def main() do
    { inputs, pre_boards } = IO.stream()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.reduce({ nil, [] }, &add_line/2)

    games = pre_boards |> Enum.map(&Bingo.init/1)

    res = Bingo.apply_all_to_games(games, inputs)

    case res do
      { winning_game, score, true } -> "Game won\n#{score}\n" <> ( winning_game |> inspect) |> IO.puts()
      anything_else -> "NOPE\n" <> ( anything_else |> inspect ) |> IO.puts()
    end

    :ok
  end

  defp add_line(line, { nil, [] }), do: {
    line |> String.split(",") |> Enum.map(&Parse.parse_decimal!/1),
    []
   }

  defp add_line(line, { inputs, boards }), do: {
    inputs,
    boards |> add_line_to_boards(
      line
      |> String.split(~r/\s+/)
      |> Enum.filter(&(!String.match?(&1, ~r/^\s*$/)))
      |> Enum.map(&Parse.parse_decimal!/1) )
  }

  defp add_line_to_boards([], line), do: [[line]]
  defp add_line_to_boards([[] | boards], line), do: [[line] | boards]
  defp add_line_to_boards([board | boards], []), do: [[] , board | boards]
  defp add_line_to_boards([board | boards], line), do: [[line | board] | boards]

end
