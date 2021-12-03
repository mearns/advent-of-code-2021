defmodule AdventOfCode2021 do

  def main(_args = [day, part | args]) do
    "Elixir.AdventOfCode2021.Puzzles.Day#{day}.Part#{part}"
    |> String.to_existing_atom()
    |> apply(:main, args)
    |> IO.puts()
  end
end
