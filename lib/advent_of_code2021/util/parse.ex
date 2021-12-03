defmodule AdventOfCode2021.Util.Parse do

  def parse_decimal!(string) do
    string |> Integer.parse(10) |> ensure_complete_parse(string)
  end

  defp ensure_complete_parse({ result, "" }, _string), do: result
  defp ensure_complete_parse({ _, _ }, string) do
      raise(RuntimeError, message: "Invalid decimal value: #{string}")
  end

end
