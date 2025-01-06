defmodule Day16 do
  def get_input() do
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")

    {y, x, grid} = AoC.grid_input(file)

    grid =
      grid
      |> Enum.group_by(fn {_, _, v} -> v end, fn {y, x, _} -> {y, x} end)
      |> Map.update!("S", fn v -> hd(v) end)
      |> Map.update!("E", fn v -> hd(v) end)

    {y, x, grid}
  end

  defp turns(src, dest) when src == dest, do: 1
  defp turns(src, dest) when src != dest, do: 1001

  def dijkstra(nodes, current, goal, visited \\ [])
  def dijkstra([], _, _, visited), do: visited

  def dijkstra(_, current, goal, visited) when current.pos == goal do
    IO.write("\n#{current.weight} #{current.dir}\n\n")
    [current | visited]
  end

  def dijkstra(nodes, current, goal, visited) do
    IO.write("\r#{length(visited)}/#{length(nodes)}")
    {cy, cx} = current.pos

    [next | nodes] =
      nodes
      |> Enum.map(fn
        %{pos: {y, ^cx}, weight: w, dir: d} when y == cy + 1 ->
          weight = current.weight + turns(current.dir, :south)

          if weight < w do
            %{pos: {y, cx}, weight: weight, dir: :south}
          else
            %{pos: {y, cx}, weight: w, dir: d}
          end

        %{pos: {y, ^cx}, weight: w, dir: d} when y == cy - 1 ->
          weight = current.weight + turns(current.dir, :north)

          if weight < w do
            %{pos: {y, cx}, weight: weight, dir: :north}
          else
            %{pos: {y, cx}, weight: w, dir: d}
          end

        %{pos: {^cy, x}, weight: w, dir: d} when x == cx + 1 ->
          weight = current.weight + turns(current.dir, :east)

          if weight < w do
            %{pos: {cy, x}, weight: weight, dir: :east}
          else
            %{pos: {cy, x}, weight: w, dir: d}
          end

        %{pos: {^cy, x}, weight: w, dir: d} when x == cx - 1 ->
          weight = current.weight + turns(current.dir, :west)

          if weight < w do
            %{pos: {cy, x}, weight: weight, dir: :west}
          else
            %{pos: {cy, x}, weight: w, dir: d}
          end

        node ->
          node
      end)
      |> Enum.sort(fn lhs, rhs -> lhs.weight < rhs.weight end)

    visited = [current | visited]
    dijkstra(nodes, next, goal, visited)
  end

  def part1 do
    IO.puts("#{__MODULE__} part 1")
    {bound_y, bound_x, grid} = get_input()

    nodes =
      grid["."]
      |> Enum.map(fn {y, x} -> %{pos: {y, x}, weight: :infinity, dir: nil} end)

    [%{pos: grid["E"], weight: :infinity, dir: nil} | nodes]
    |> Enum.sort(fn lhs, rhs -> lhs.weight < rhs.weight end)
    |> dijkstra(%{pos: grid["S"], weight: 0, dir: :east}, grid["E"])

    # |> then(fn visited ->
    #  0..bound_y
    #  |> Enum.map(fn y ->
    #    0..bound_x
    #    |> Enum.each(fn x ->
    #      v = visited |> Enum.find(fn %{pos: pos} -> pos == {y, x} end)

    #      if v != nil do
    #        case v.dir do
    #          :north -> IO.write("^")
    #          :south -> IO.write("v")
    #          :east -> IO.write(">")
    #          :west -> IO.write("<")
    #          _ -> IO.write("_")
    #        end
    #      else
    #        nodes
    #        |> Enum.find(fn %{pos: pos, weight: _, dir: _, path: _} -> pos == {y, x} end)
    #        |> then(fn
    #          nil -> IO.write("#")
    #          _ -> IO.write(".")
    #        end)
    #      end
    #    end)

    #    IO.write("\n")
    #  end)
    # end)
  end

  def part2 do
    IO.puts("#{__MODULE__} part 2")
  end
end

Day16.part1()
