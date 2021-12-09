defmodule AdventOfCode2021.Puzzles.Day7.Part1 do

  alias AdventOfCode2021.Util.Parse
  alias AdventOfCode2021.Util.Debug

  @spec main() :: pos_integer()
  def main() do
    { _at_point, score } = load(:real)
    |> find_max_and_min_with_scores()
    |> find_preferred_position()
    |> Debug.tee()
    score
  end

  defp load(:test), do: load_from_text("16,1,2,0,4,2,7,1,2,14")
  defp load(_), do: IO.stream() |> load_from_stream()

  defp find_preferred_position({ _numbers, { min_v, score_at_min }, { max_v, _score_at_max }}) when min_v == max_v,
    do: { min_v, score_at_min }

  defp find_preferred_position({ numbers, min_pt = { min_v, _score_at_min }, max_pt = { max_v, _score_at_max }}) do
    { low_mid, high_mid } = mid_points(min_v, max_v)
    low_score = get_score(numbers, low_mid)
    high_score = get_score(numbers, high_mid)
    # "Looking for best position: #{min_pt |> inspect}, #{{ low_mid, low_score } |> inspect}, #{{ high_mid, high_score } |> inspect}, #{max_pt |> inspect}" |> IO.puts()
    cond do
      low_mid > high_mid -> raise "Oh bother, I crossed the beams: #{low_mid} > #{high_mid}"
      low_mid == high_mid -> { low_mid, low_score }
      low_score <= high_score -> find_preferred_position({ numbers, min_pt, { high_mid, high_score }})
      true -> find_preferred_position({ numbers, { low_mid, low_score }, max_pt })
    end
  end

  defp mid_points(min_v, max_v) do
    (max_v - min_v) / 3
    |> ceil()
    |> (&({ min_v + &1, max_v - &1 })).()
  end

  defp load_from_stream(stream) do
    stream
    |> Stream.take(1)
    |> Enum.map(&String.trim_trailing/1)
    |> List.first()
    |> load_from_text()
  end

  defp load_from_text(text) do
    text
    |> String.split(",")
    |> Enum.map(&Parse.parse_decimal!/1)
  end

  defp find_max_and_min_with_scores(numbers) do
    numbers
    |> find_max_and_min()
    |> (fn { numbers, min_v, max_v } ->
      {
        numbers,
        min_v |> value_and_score(numbers),
        max_v |> value_and_score(numbers)
      }
    end).()
  end

  defp value_and_score(at_point, numbers), do: { at_point, numbers |> get_score(at_point) }

  defp get_score(numbers, at_point) do
    numbers
    |> Enum.map(&(abs(&1 - at_point)))
    |> Enum.sum()
  end

  defp find_max_and_min(numbers), do: { numbers, find_min(numbers), find_max(numbers) }

  defp find_min(numbers) do
    numbers |> Enum.reduce(nil, &which_is_min/2)
  end

  defp find_max(numbers) do
    numbers |> Enum.reduce(nil, &which_is_max/2)
  end

  defp which_is_max(value, nil), do: value
  defp which_is_max(a, b) when a >= b, do: a
  defp which_is_max(a, b) when a < b, do: b

  defp which_is_min(value, nil), do: value
  defp which_is_min(a, b) when a <= b, do: a
  defp which_is_min(a, b) when a > b, do: b


end
