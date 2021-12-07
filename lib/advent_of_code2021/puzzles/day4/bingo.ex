defmodule AdventOfCode2021.Puzzles.Day4.Bingo do

  alias AdventOfCode2021.Puzzles.Day4.Bingo
  alias AdventOfCode2021.Util.Debug

  @board_dim 5

  defstruct(
    rows: [],
    cols: []
  )

  def init(card_by_rows) do
    flat_array = card_by_rows |>Enum.flat_map(&(&1))
    flat_array
    |> Enum.with_index()
    |> Enum.reduce(
      { %{}, %{} },
      fn ({ value, index }, { rows, cols }) ->
        {
          rows |> add_to_span_map(div(index, @board_dim), value),
          cols |> add_to_span_map(rem(index, @board_dim), value)
        }
      end
    )
    |> (fn ({ rows, cols}) -> %Bingo{
      rows: rows |> Map.values(),
      cols: cols |> Map.values()
    } end).()
  end

  defp add_to_span_map(span_map, span_index, value) do
    span_map |> Map.update(span_index, [value], &([ value | &1 ]))
  end

  def apply_all_to_games(games, [ ]), do: games

  def apply_all_to_games(games, [ value | values]) do
    case apply_to_games(games, value) do
      { game, true } -> { game, game |> get_score(value), true }
      games -> apply_all_to_games(games, values)
    end
  end

  def apply_to_games([ ], _value), do: []

  def apply_to_games([ game | games ], value) do
    case apply_value(game, value) do
      { game, true } -> { game, true }
      # Return shape here is wrong when it wins, it returns { game, true }, this is expecting it to returns the
      # list of updated games.
      { game, false } -> [ game | apply_to_games(games, value) ]
    end
  end

  def apply_value(game, value) do
    game
    |> mark(value)
    |> check_win()
  end

  defp mark(game = %Bingo{rows: rows, cols: cols}, value) do
    %Bingo{ game |
      rows: rows |> Enum.map(&(mark_in_span(&1, value))),
      cols: cols |> Enum.map(&(mark_in_span(&1, value)))
    }
  end

  defp mark_in_span(span, value) do
    span |> Enum.filter(&(&1 != value))
  end

  defp check_win(game), do: { game, game |> wins?() }

  defp wins?(%Bingo{rows: rows, cols: cols }) do
    [rows | cols] |> Enum.any?(&Enum.empty?/1)
  end

  def get_score(%Bingo{rows: rows}, value) do
    (rows |> Enum.map(&Enum.sum/1) |> Enum.sum()) * value
  end
end
