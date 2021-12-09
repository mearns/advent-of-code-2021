defmodule AdventOfCode2021.Puzzles.Day5.Line do

  alias AdventOfCode2021.Util.Parse

  @type line :: { integer, integer, integer, integer }

  @spec init(String.t) :: line
  def init(text) do
    ~r/^([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)$/
    |> Regex.run(text)
    |> parse_match()
  end

  @spec parse_match([String.t, ...]) :: line
  defp parse_match([_, x1, y1, x2, y2]) do
    [x1, y1, x2, y2]
    |> Enum.map(&Parse.parse_decimal!/1)
    |> (fn ([x1, y1, x2, y2]) -> { x1, y1, x2, y2 } end).()
  end

  def is_horizontal_or_vertical({ x1, _y1, x2, _y2 }) when x1 == x2, do: true
  def is_horizontal_or_vertical({ _x1, y1, _x2, y2 }) when y1 == y2, do: true
  def is_horizontal_or_vertical({ _x1, _y1, _x2, _y2 }), do: false

  # Single points
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y1 == y2 do
    map |> add_point_to_map(x1, y1)
  end

  # Vertical Lines
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y1 < y2 do
    map
    |> add_point_to_map(x1, y1)
    |> (&(add_line_to_map({ x1, y1 + 1, x2, y2 }, &1))).()
  end
  # Reversed
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y2 < y1, do: add_line_to_map({ x2, y2, x1, y1 }, map)

  # Horiztonal Lines
  def add_line_to_map({ x1, y1, x2, y2 }, map) when y1 == y2 and x1 < x2 do
    map
    |> add_point_to_map(x1, y1)
    |> (&(add_line_to_map({ x1 + 1, y1, x2, y2 }, &1))).()
  end
  # Reversed
  def add_line_to_map({ x1, y1, x2, y2 }, map) when y1 == y2 and x2 < x1, do: add_line_to_map({ x2, y2, x1, y1 }, map)

  # Diagonals Moving Right
  # Up and to the right
  def add_line_to_map( line = { x1, y1, x2, y2 }, map) when x2 > x1 and y2 > y1 do
    line |> ensure_diagonal()
    map
    |> add_point_to_map(x1, y1)
    |> (&(add_line_to_map({ x1 + 1, y1 + 1, x2, y2 }, &1))).()
  end
  # Up and to the Left
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x2 < x1 and y2 > y1, do: add_line_to_map({ x2, y2, x1, y1 }, map)
  # Down and to the right
  def add_line_to_map( line = { x1, y1, x2, y2 }, map) when x2 > x1 and y2 < y1 do
    line |> ensure_diagonal()
    map
    |> add_point_to_map(x1, y1)
    |> (&(add_line_to_map({ x1 + 1, y1 - 1, x2, y2 }, &1))).()
  end
  # Down and to the right
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x2 < x1 and y2 < y1, do: add_line_to_map({ x2, y2, x1, y1 }, map)

  defp add_point_to_map(map, x, y), do: map |> Map.update("#{x}x#{y}", 1, &(&1 + 1))

  defp ensure_diagonal({ x1, y1, x2, y2 }) when abs(x1 - x2) == abs(y1 - y2), do: :ok
  defp ensure_diagonal({ x1, y1, x2, y2 }) do
    raise "Line is not diagonal: {#{x1}, #{y1}, #{x2}, #{y2}}"
  end

end
