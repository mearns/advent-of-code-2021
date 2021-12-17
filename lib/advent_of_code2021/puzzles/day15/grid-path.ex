defmodule AdventOfCode2021.Puzzles.Day15.GridPath do

  alias AdventOfCode2021.Puzzles.Day15.GridPath
  alias AdventOfCode2021.Puzzles.Day15.Helpers
  alias AdventOfCode2021.Util.Debug

  @max_cost 9

  defstruct [
    dest: nil,
    rev_path: [],
    has: MapSet.new(),
    concrete_cost: 0,
    bcc: nil,
    wcc: nil,
    complete: false
  ]

  def init(dest = { x, y }, start = { sx, sy } \\ { 0, 0 }) do
    dist = get_distance(start, dest)
    %GridPath{
      dest: { x, y },
      rev_path: [ start ],
      has: MapSet.new() |> MapSet.put(start |> point_to_key()),
      bcc: dist,
      wcc: @max_cost * dist,
      complete: sx == x and sy == y
    }
  end

  def path_length(%GridPath{ rev_path: rev_path }), do: rev_path |> length()

  defp get_distance({ sx, sy }, { ex, ey }) do
    dx = ex - sx
    dy = ey - sy
    dx + dy
  end

  defp point_to_key({ x, y }), do: "#{x},#{y}"

  def last_point(%GridPath{ rev_path: [ start | _ ]}), do: start

  def complete?(%GridPath{ complete: complete }), do: complete

  def get_path(%GridPath{ rev_path: rev_path }), do: rev_path |> Enum.reverse()

  def get_best_case_cost(%GridPath{bcc: bcc}), do: bcc

  def get_worst_case_cost(%GridPath{wcc: wcc}), do: wcc

  def get_concrete_cost(%GridPath{ concrete_cost: concrete_cost }), do: concrete_cost

  def get_destination(%GridPath{ dest: dest }), do: dest

  def extend({ :self_intersecting,  path, intersected_at }, _extend_to = {_x, _y} , _cost) do
    { :self_intersecting, path, intersected_at }
  end

  def extend({ :ok, path = %GridPath{} }, extend_to = {_x, _y} , cost) do
    path |> extend(extend_to, cost)
  end

  def extend(%GridPath{ complete: true }, _extend_to = {_x, _y} , _cost) do
    raise "The path is already complete, please don't extend it."
  end

  def extend(path = %GridPath{ dest: dest = { destx, desty } }, extend_to = {x, y} , cost) do
    dist = get_distance(extend_to, dest)
    key = extend_to |> point_to_key()
    cc = path.concrete_cost + cost
    case path.has |> MapSet.member?(key) do
      true -> { :self_intersecting, path, extend_to }
      false ->
        {
          :ok,
          %GridPath {
            dest: dest,
            rev_path: [ extend_to | path.rev_path ],
            has: path.has |> MapSet.put(key),
            concrete_cost: cc,
            bcc: cc + dist,
            wcc: cc + (@max_cost * dist),
            complete: x == destx and y == desty
          }
        }
    end
  end

  def more_expensive?(path = %GridPath{ }, { _bcc, wcc }), do: path.bcc > wcc

end
