defmodule AdventOfCode2021.Puzzles.Day2.Part2 do

  alias AdventOfCode2021.Util

  defp parse_command_line(line) do
    [ _ , mneu, arg ] = Regex.run(~r/^([a-z]+)\s+([0-9]+)\s*$/, line)
    [ mneu, arg |> Util.Parse.parse_decimal!() ]
  end

  defp init() do
    { 0, 0, 0 }
  end

  defp apply_command(["forward", d], { x, z, aim }), do: { x + d, z + d * aim, aim  }
  defp apply_command(["up", d], { x, z, aim }), do: { x, z, aim - d }
  defp apply_command(["down", d], { x, z, aim }), do: { x, z, aim + d }

  defp multiply({ x, z, _aim }), do: x * z

  def main() do
    IO.stream()
    |> Enum.map(&parse_command_line/1)
    |> Enum.reduce(init(), &apply_command/2)
    |> multiply()
  end

end
