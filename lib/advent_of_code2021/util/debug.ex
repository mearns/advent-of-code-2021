defmodule AdventOfCode2021.Util.Debug do
  def tee(value) do
    value |> inspect() |> IO.puts()
    value
  end
end
