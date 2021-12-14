defmodule AdventOfCode2021.Util do

  def inc(value, by \\ 1), do: value + by

  def inc_count_map(count_map, key, by) do
    count_map |> Map.update(key, by, &(&1 |> inc(by)))
  end

end
