defmodule AdventOfCode2021.Puzzles.Day9.Helpers do

  alias AdventOfCode2021.Util.Parse

  def load_lines(lines) do
    lines
    |> Enum.reduce({}, &apply_line/2)
    |> process_last_line()
  end

  def load_from_text(lines_of_text) do
    lines_of_text
    |> Stream.map(fn line -> line |> String.graphemes() |> Enum.map(&Parse.parse_decimal!/1) end)
    |> load_lines()
  end

  def get_risk_level({ height, _linenum }), do: height + 1

  def apply_line(first_line, { }), do: { { first_line } }

  def apply_line(next_line, { { first } } )do
    [] |> find_low_points_for_lines({ first, next_line }, 0)
  end

  def apply_line(next_line, { existing_low_points, { first, second }, 1 } ) do
    existing_low_points |> find_low_points_for_lines({ first, second, next_line }, 1 )
  end

  def apply_line(next_line, { existing_low_points, { _first, second, third }, linenum } ) do
    existing_low_points |> find_low_points_for_lines({ second, third, next_line }, linenum)
  end

  defp find_low_points_for_lines(existing_low_points, lines, linenum) do
      {
        existing_low_points |> find_more_low_points(lines, linenum, :first_column),
        lines,
        linenum + 1
      }
  end


  @spec find_more_low_points(
    [ pos_integer ],
    ( { [ pos_integer ], [ pos_integer ]} | { [ pos_integer ] , [ pos_integer ], [ pos_integer ] } ),
    pos_integer,
    ( :first_column | :not_first_column )
  ) :: [ pos_integer ]


  # First column, first line.
  defp find_more_low_points(existing_low_points = [], { [ f1, f2 | ft ], [ s1, s2 | st ] }, linenum, :first_column) do
    existing_low_points
    |> add_if_low_point(linenum, f1, [ f2, s1 ])
    |> find_more_low_points({ [ f1, f2 | ft ], [ s1, s2 | st ] }, linenum, :not_first_column)
  end

  # First column, middle lines
  defp find_more_low_points(existing_low_points, { [ f1, f2 | ft ], [ s1, s2 | st ], [ t1, t2 | tt ] }, linenum, :first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s1, [ f1, s2, t1 ])
    |> find_more_low_points({ [ f2 | ft ], [ s2 | st ], [ t2 | tt ] }, linenum, :not_first_column )
  end

  # Middle columns, first line
  defp find_more_low_points(existing_low_points, { [ f1, f2, f3 | ft ], [ _s1, s2, s3 | st ] }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, f2, [ f1, f3, s2 ])
    |> find_more_low_points({ [ f2, f3 | ft ], [ s2, s3 | st ] }, linenum, :not_first_column)
  end

  # Middle columns, middle lines
  defp find_more_low_points(existing_low_points, { [ _f1, f2, f3 | ft ], [ s1, s2, s3 | st ], [ _t1, t2, t3 | tt ] }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s2, [ f2, s1, s3, t2 ])
    |> find_more_low_points({ [ f2, f3 | ft ], [ s2, s3 | st ], [ t2, t3 | tt ] }, linenum, :not_first_column)
  end

  # Last column, first line
  defp find_more_low_points(existing_low_points, { [ f1, f2 ], [ _s1, s2 ] }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, f2, [ f1, s2 ])
  end

  # Last column, middle lines
  defp find_more_low_points(existing_low_points, { [ _f1, f2 ], [ s1, s2 ], [ _t1, t2 ] }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s2, [ f2, s1, t2 ])
  end

  # We've always processed the previously added line when we add a new one. So when we get to the end,
  # we've never processed the last line. We do that now.
  defp process_last_line({ existing_low_points, { _first, second, third }, linenum}) do
    existing_low_points |> find_more_low_points_in_last_line({ second, third }, linenum, :first_column)
  end

  # First column, last line
  defp find_more_low_points_in_last_line(existing_low_points, { [ f1, f2 | ft ], [ s1, s2 | st ] }, linenum, :first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s1, [ f1, s2 ])
    |> find_more_low_points_in_last_line({ [f2 | ft ], [ s2 | st ] }, linenum, :not_first_column)
  end

  # Middle columns, last line
  defp find_more_low_points_in_last_line(existing_low_points, { [ _f1, f2, f3 | ft ], [ s1, s2, s3 | st ] }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s2, [ f2, s1, s3 ])
    |> find_more_low_points_in_last_line({ [ f2, f3 | ft ], [ s2, s3 | st ] }, linenum, :not_first_column)
  end

  # Last column, last line
  defp find_more_low_points_in_last_line(existing_low_points, { [ _f1, f2 ], [ s1, s2]  }, linenum, :not_first_column) do
    existing_low_points
    |> add_if_low_point(linenum, s2, [ f2, s1 ])
  end

  @spec add_if_low_point([ pos_integer ], pos_integer, pos_integer, [ pos_integer ]) :: [ pos_integer ]

  defp add_if_low_point(existing_low_points, linenum, pt, neighbors) do
    cond do
      is_low_point(pt, neighbors) -> [ { pt, linenum } | existing_low_points ]
      true -> existing_low_points
    end
  end


  defp is_low_point(pt, [ n | [] ]), do: pt < n
  defp is_low_point(pt, [ n1 | nt ]) when pt < n1, do: is_low_point(pt, nt)
  defp is_low_point(pt, [ n1 | _nt ]) when pt >= n1, do: false

end
