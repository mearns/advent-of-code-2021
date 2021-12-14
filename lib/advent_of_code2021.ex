defmodule AdventOfCode2021 do

  def main(_args = [day, part, "--sample" | args]) do
    run_day(day, part, :use_sample, args)
  end

  def main(_args = [day, part | args]) do
    run_day(day, part, :use_real, args)
  end

  defp run_day(day, part, what_to_use, args) do
    "Elixir.AdventOfCode2021.Puzzles.Day#{day}.Part#{part}"
    |> String.to_existing_atom()
    |> apply(:main, [ what_to_use | args])
    |> IO.puts()
  end
end
