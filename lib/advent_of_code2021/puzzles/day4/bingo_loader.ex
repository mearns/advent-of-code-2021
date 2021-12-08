defmodule AdventOfCode2021.Puzzles.Day4.BingoLoader do

  alias AdventOfCode2021.Puzzles.Day4.Bingo
  alias AdventOfCode2021.Util.Parse

  @spec load_from_stream(IO.stream) :: { [Bingo.bingo_value], [Bingo.bingo_game] }
  def load_from_stream(stream) do
    { inputs, pre_boards } = stream
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.reduce({ nil, [] }, &add_line/2)

    { inputs, pre_boards |> Enum.map(&Bingo.init/1) }
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
