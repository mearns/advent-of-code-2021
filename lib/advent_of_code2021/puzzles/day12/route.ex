defmodule AdventOfCode2021.Puzzles.Day12.Route do

  alias AdventOfCode2021.Util
  alias AdventOfCode2021.Puzzles.Day12.Route

  defstruct [
    rev_path: [],
    visit_counts: %{}
  ]

  def init(), do: %Route{}

  def fork(route = %Route{}, next_node) do
      %Route{
        rev_path: [next_node | route.rev_path ] ,
        visit_counts: route.visit_counts |> Map.update(next_node, 1, &Util.inc/1)
      }
  end

  def visited?(%Route{ visit_counts: visit_counts }, node) do
    visit_counts |> Map.get(node, 0) > 0
  end

  def as_string(%Route{ rev_path: rev_path }), do: rev_path_to_string(rev_path)

  defp rev_path_to_string([]), do: ""
  defp rev_path_to_string([last, first]), do: first <> "," <> last
  defp rev_path_to_string([tail | leading]), do: (leading |> rev_path_to_string) <> "," <> tail

end
