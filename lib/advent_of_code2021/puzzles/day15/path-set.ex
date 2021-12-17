defmodule AdventOfCode2021.Puzzles.Day15.PathSet do

  alias AdventOfCode2021.Puzzles.Day15.Helpers
  alias AdventOfCode2021.Puzzles.Day15.Grids
  alias AdventOfCode2021.Puzzles.Day15.GridPath
  alias AdventOfCode2021.Puzzles.Day15.PathSet
  alias AdventOfCode2021.Util.Debug

  defstruct [
    bcc: nil,
    wcc: nil,
    paths: []
  ]

  def init(), do: %PathSet{}

  def prune(self = %PathSet{ bcc: nil }), do: self
  def prune(self = %PathSet{ wcc: nil }), do: self
  def prune(%PathSet{ bcc: bcc, wcc: wcc, paths: paths }) do
    %PathSet{
      bcc: bcc,
      wcc: wcc,
      paths: paths
      |> Enum.filter(&(not (&1 |> GridPath.more_expensive?({ bcc, wcc }))))
    }
  end

  def size(%PathSet{ paths: paths }), do: paths |> length()

  def add(self = %PathSet{}, path = %GridPath{}) do
    cond do
      path.bcc > self.wcc -> self
      true -> %PathSet{
        paths: [ path | self.paths ],
        bcc: Helpers.min_cost(path.bcc, path |> GridPath.get_best_case_cost()),
        wcc: Helpers.min_cost(path.wcc, path |> GridPath.get_worst_case_cost()),
      }
      |> prune()
    end
  end

  def extend_to_four_neighbors(self = %PathSet{}, grid = %Grids{}) do
    self.paths
    |> Enum.reduce(init(), fn (parent_path, path_set) ->
      parent_path
      |> GridPath.last_point()
      |> grid.reduce_on_four_neighbors.(path_set, fn (value, path_set, neighbor_point, _w, _h) ->
        case parent_path |> GridPath.extend(neighbor_point, value) do
          { :ok, child_path } ->
            "Adding child path of length #{child_path |> GridPath.path_length()}" |> IO.puts()
            path_set |> add(child_path)
          { :self_intersecting, _, _ } -> path_set
        end
      end)
    end)
  end

  def complete?(self = %PathSet{}) do
    self.paths |> Enum.all?(&GridPath.complete?/1)
  end

  def is_complete(self = %PathSet{}) do
    { self |> complete?(), self }
  end

end
