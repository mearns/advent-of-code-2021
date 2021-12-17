defmodule AdventOfCode2021.Puzzles.Day15.Grids do

  alias AdventOfCode2021.Puzzles.Day15.Grids
  alias AdventOfCode2021.Util.Parse

  defstruct [:reduce_on_four_neighbors, :inspect, :width, :height]

  defimpl Inspect, for: AdventOfCode2021.Puzzles.Day15.Grids do
    def inspect(%Grids{inspect: do_inspect}, opts) do
      do_inspect.(opts)
    end
  end

  def load_from_text_lines(lines) do
    lines
    |> Stream.map(fn line ->
      line
      |> String.split(~r/(?=[0-9])/)
      |> then(fn [ "" | row ] -> row end)
      |> then(fn row -> row |> Enum.map(&Parse.parse_decimal!/1) end)
    end)
    |> Enum.reduce({ 0, 0, %{} }, fn (row, { _, row_num, map }) ->
        row |> Enum.reduce({ 0, map }, fn (cell_value, { col_num, map }) ->
          {
            col_num + 1,
            map |> Map.put({ row_num, col_num } |> point_to_key(), cell_value)
          }
        end)
        |> then(fn { width, map } -> { width, row_num + 1, map } end)
    end)
    |> init()
  end

  def init({ width, height, map }) do
    %Grids{

      reduce_on_four_neighbors: fn { x, y }, seed, func ->
        get_four_neighbors({ x, y }, width, height)
        |> Enum.reduce(seed, fn ({ x, y }, acc) ->
          map
          |> get({x, y})
          |> then(&(func.(&1, acc, { x, y }, width, height)))
        end)
      end,

      inspect: fn _opts ->
        (0..height-1)
        |> Enum.map(fn row ->
          (0..width-1)
          |> Enum.map(fn col ->
            map |> Map.get({ row, col } |> point_to_key())
          end)
          |> Enum.join("")
        end)
        |> Enum.join("\n")
      end,

      width: fn -> width end,

      height: fn -> height end,
    }
  end

  def get(map, { x, y }), do: map |> Map.get({x, y} |> point_to_key())

  defp point_to_key({ x, y}), do: "#{x},#{y}"

  defp get_four_neighbors({ x, y }, grid_w, grid_h) do
    [
      {0, -1},
      {-1, 0},
      {1, 0},
      {0, 1}
    ]
    |> Enum.map(fn { dx, dy } -> { x + dx, y + dy } end)
    |> Enum.filter(fn { x, y } -> x >= 0 and y >= 0 and x < grid_w and y < grid_h end)
  end
end
