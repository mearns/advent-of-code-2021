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

  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y2 < y1, do: add_line_to_map({ x2, y2, x1, y1 }, map)
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y1 == y2 do
    map |> Map.update("#{x1}x#{y1}", 1, &(&1 + 1))
  end
  def add_line_to_map({ x1, y1, x2, y2 }, map) when x1 == x2 and y1 < y2 do
    map
    |> Map.update("#{x1}x#{y1}", 1, &(&1 + 1))
    |> (&(add_line_to_map({ x1, y1 + 1, x2, y2 }, &1))).()
  end

  def add_line_to_map({ x1, y1, x2, y2 }, map) when y1 == y2 and x2 < x1, do: add_line_to_map({ x2, y2, x1, y1 }, map)
  def add_line_to_map({ x1, y1, x2, y2 }, map) when y1 == y2 and x1 == x2 do
    map |> Map.update("#{x1}x#{y1}", 1, &(&1 + 1))
  end
  def add_line_to_map({ x1, y1, x2, y2 }, map) when y1 == y2 and x1 < x2 do
    map
    |> Map.update("#{x1}x#{y1}", 1, &(&1 + 1))
    |> (&(add_line_to_map({ x1 + 1, y1, x2, y2 }, &1))).()
  end

end
