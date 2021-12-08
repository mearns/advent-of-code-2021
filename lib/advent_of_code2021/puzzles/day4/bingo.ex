defmodule AdventOfCode2021.Puzzles.Day4.Bingo do

  alias AdventOfCode2021.Puzzles.Day4.Bingo
  # alias AdventOfCode2021.Util.Debug

  @board_dim 5
  @typep index :: 0..4

  @type bingo_value :: pos_integer()
  @type span :: [bingo_value(), ...]

  @opaque bingo_game :: %Bingo{
    rows: [span, ...],
    cols: [span, ...]
  }
  defstruct(
    rows: [],
    cols: []
  )

  @spec init([span, ...]) :: bingo_game()
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

  @typep span_map :: %{ index => span }
  @spec add_to_span_map(span_map, index, bingo_value) :: span_map
  defp add_to_span_map(span_map, span_index, value) do
    span_map |> Map.update(span_index, [value], &([ value | &1 ]))
  end

  @spec mark_in_all_games([ bingo_game ], bingo_value) :: [ bingo_game ]
  def mark_in_all_games([ game | games ], value) do
    [ game |> mark(value) | mark_in_all_games(games, value) ]
  end
  def mark_in_all_games([ ], _value), do: []


  @spec find_winner([bingo_game]) :: ( bingo_game | nil )
  def find_winner([]), do: nil
  def find_winner([ game | games ]) do
    case game |> wins?() do
      true -> game
      false -> find_winner(games)
    end
  end

  # Helper method to mark the given value in the given game.
  @spec mark(bingo_game, bingo_value) :: bingo_game
  defp mark(game = %Bingo{rows: rows, cols: cols}, value) do
    %Bingo{ game |
      rows: rows |> Enum.map(&(mark_in_span(&1, value))),
      cols: cols |> Enum.map(&(mark_in_span(&1, value)))
    }
  end

  @spec mark(span, bingo_value) :: span
  defp mark_in_span(span, value) do
    span |> Enum.filter(&(&1 != value))
  end

  @spec wins?(bingo_game) :: boolean
  def wins?(%Bingo{rows: rows, cols: cols }) do
    (rows |> Enum.any?(&Enum.empty?/1)) || (cols |> Enum.any?(&Enum.empty?/1))
  end

  # Get the score of a winning board. Assumes the board is in fact winning and
  # is left in the state of having just applied to the last (winning) value,
  # which is given as the second argument.
  @spec get_score(bingo_game, bingo_value) :: pos_integer()
  def get_score(%Bingo{rows: rows}, value) do
    (rows |> Enum.map(&Enum.sum/1) |> Enum.sum()) * value
  end
end
