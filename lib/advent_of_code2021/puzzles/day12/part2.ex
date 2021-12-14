defmodule AdventOfCode2021.Puzzles.Day12.Part2 do

  alias AdventOfCode2021.Puzzles.Day12.Helpers
  alias AdventOfCode2021.Puzzles.Day12.Route
  alias AdventOfCode2021.Puzzles.Day12.Caves
  alias AdventOfCode2021.Util.Debug

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    what_to_use
    |> Helpers.load()
    |> find_paths()
    |> length()
  end

  defp find_paths(caves = %Caves{}), do: find_paths([], caves, Route.init(), "start")

  defp find_paths(full_paths, %Caves{}, route, _next_node = "end"), do: [ route |> Route.as_string() | full_paths ]

  defp find_paths(full_paths, caves = %Caves{}, route, next_node) do
    cond do
      can_visit(route, next_node) -> caves |> Caves.reduce_on_neighbors(next_node, full_paths, fn (child, full_paths) ->
        full_paths |> find_paths(caves, route |> Route.fork(next_node), child)
      end)
      true -> full_paths
    end
  end

  defp is_small_cave(node), do: ~r/[a-z]+/ |> Regex.match?(node)

  defp can_visit(route, node) do
    cond do
      not is_small_cave(node) -> true
      not (route |> Route.visited?(node)) -> true
      node == "start" -> false
      node == "end" -> false
      route |> any_small_cave_visited_twice() -> false
      true -> true
    end
  end

  defp any_small_cave_visited_twice(route = %Route{}) do
    route
    |> Route.nodes_visited()
    |> Enum.filter(&is_small_cave/1)
    |> Enum.any?(fn node -> (route |> Route.visit_count(node)) > 1 end)
  end

end
