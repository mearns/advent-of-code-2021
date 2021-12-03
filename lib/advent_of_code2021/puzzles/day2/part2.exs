defmodule Puzzle do

  defp parseCommandLine(line) do
    [ _ , mneu, arg ] = Regex.run(~r/^([a-z]+)\s+([0-9]+)\s*$/, line)
    [ mneu, arg |> parseDecimal!() ]
  end

  defp parseDecimal!(string) do
    { result, remainder } = string |> Integer.parse(10)
    case remainder do
     "" -> result
      _ -> raise(RuntimeError, message: "Invalid decimal value: #{string}")
    end
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
    |> Enum.map(&parseCommandLine/1)
    |> Enum.reduce(init(), &apply_command/2)
    |> multiply()
  end

end

Puzzle.main() |> IO.puts()
