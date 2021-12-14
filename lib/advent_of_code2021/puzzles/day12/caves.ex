defmodule AdventOfCode2021.Puzzles.Day12.Caves do

  alias AdventOfCode2021.Puzzles.Day12.Caves

  defstruct [
    :neighbors
  ]

  def init(), do: %Caves{
    neighbors: %{}
  }

  def add_pair(caves = %Caves{}, { a, b }) do
    caves |> add_directed_path(a, b) |> add_directed_path(b, a)
  end

  defp add_directed_path(caves = %Caves{ neighbors: neighbors }, a, b) do
    %Caves{
      caves |
      neighbors: neighbors |> Map.put_new(a, MapSet.new()) |> Map.update!(a, &( &1 |> MapSet.put(b) ))
    }
  end

  def reduce_on_neighbors(%Caves{ neighbors: neighbors }, node, seed, func) do
    neighbors
    |> Map.get(node, MapSet.new())
    |> Enum.reduce(seed, func)
  end

end
