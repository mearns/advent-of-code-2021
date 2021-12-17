defmodule AdventOfCode2021.Puzzles.Day15.Part1 do

  alias AdventOfCode2021.Puzzles.Day15.Helpers
  alias AdventOfCode2021.Puzzles.Day15.GridPath
  alias AdventOfCode2021.Puzzles.Day15.Grids
  alias AdventOfCode2021.Puzzles.Day15.PathSet
  alias AdventOfCode2021.Util.Debug

  @spec main( :use_real | :use_sample ) :: pos_integer
  def main(what_to_use) do
    grid = what_to_use |> Helpers.load()
    grid |> then(fn (grid = %Grids{ width: width, height: height }) ->
      dest = { width.(), height.() }
      path_set = PathSet.init() |> PathSet.add(GridPath.init(dest))
      path_set |> run(grid)
    end)
    |> Debug.tee()
    10
  end

  defp run(path_set = %PathSet{}, grid = %Grids{}) do
    case path_set
    |> PathSet.extend_to_four_neighbors(grid)
    |> PathSet.is_complete() do
      { true, path_set } -> path_set
      { false, path_set } -> path_set |> run(grid)
    end
  end

end
