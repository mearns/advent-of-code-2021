defmodule AdventOfCode2021.Puzzles.Day12.Part1 do

  alias AdventOfCode2021.Puzzles.Day12.Helpers
  alias AdventOfCode2021.Puzzles.Day12.Route
  alias AdventOfCode2021.Puzzles.Day12.Caves
  alias AdventOfCode2021.Util.Debug

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    what_to_use
    |> Helpers.load()
    |> find_paths()
    |> Debug.tee()
    |> length()
  end

  defp find_paths(caves = %Caves{}), do: find_paths([], caves, Route.init(), "start")

  defp find_paths(full_paths, %Caves{}, route, _next_node = "end"), do: [ route |> Route.as_string() | full_paths ]

  defp find_paths(full_paths, caves = %Caves{}, route, next_node) do
    cond do
      (next_node |> is_small_cave()) and (route |> Route.visited?(next_node)) ->
        # Couldn't reach end on this route without visiting the same small cave twice.
        full_paths
      true -> caves |> Caves.reduce_on_neighbors(next_node, full_paths, fn (child, full_paths) ->
        full_paths |> find_paths(caves, route |> Route.fork(next_node), child)
      end)
    end
  end

  defp is_small_cave(node), do: ~r/[a-z]+/ |> Regex.match?(node)

end
