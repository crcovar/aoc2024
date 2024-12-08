defmodule Day08 do
  defp input() do
    map =
      File.stream!("./input.txt")
      |> Stream.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, "", trim: true))

    x = length(hd(map))
    y = length(map)

    map =
      map
      |> Stream.map(&Enum.with_index(&1))
      |> Stream.with_index()
      |> Stream.flat_map(fn row ->
        {cols, y} = row

        cols
        |> Enum.map(fn col ->
          {v, x} = col
          {y, x, v}
        end)
      end)
      |> Stream.filter(fn
        {_, _, "."} -> false
        _ -> true
      end)
      |> Enum.group_by(fn {_, _, k} -> k end, fn {y, x, _} -> {y, x} end)

    {y, x, map}
  end

  defp in_bounds?({y, x}, bound_y, bound_x) do
    y < bound_y and y >= 0 and x < bound_x and x >= 0
  end

  defp antinodes({ay, ax}, {by, bx}) do
    {dy, dx} = {ay - by, ax - bx}
    n1 = {by - dy, bx - dx}
    n2 = {ay + dy, ax + dx}
    [n1, n2]
  end

  defp antinodes(a, b, bound_y, bound_x) do
    {ay, ax} = a
    {by, bx} = b
    m = {ay - by, ax - bx}
    [a, b] ++ antinodes(b, m, :down, bound_y, bound_x) ++ antinodes(a, m, :up, bound_y, bound_x)
  end

  defp antinodes({y, x}, m, :up, by, bx) do
    {my, mx} = m
    n = {y + my, x + mx}

    case n do
      {y, x} when y < by and y >= 0 and x < bx and x >= 0 ->
        [n] ++ antinodes({y, x}, m, :up, by, bx)

      _ ->
        []
    end
  end

  defp antinodes({y, x}, m, :down, by, bx) do
    {my, mx} = m
    n = {y - my, x - mx}

    case n do
      {y, x} when y < by and y >= 0 and x < bx and x >= 0 ->
        [n] ++ antinodes({y, x}, m, :down, by, bx)

      _ ->
        []
    end
  end

  defp find_antinodes(list, head \\ nil)
  defp find_antinodes([], _), do: []

  defp find_antinodes([head | tail], nil) do
    find_antinodes(tail, head) ++ find_antinodes(tail)
  end

  defp find_antinodes([h | tail], head) do
    # IO.puts("Finding antinodes for #{inspect(head)}, #{inspect(h)} #{inspect(tail)}")
    antinodes(head, h) ++ find_antinodes(tail, head)
  end

  defp find_antinodes(list, bound_y, bound_x, head \\ nil)
  defp find_antinodes([], _, _, _), do: []

  defp find_antinodes([head | tail], bound_y, bound_x, nil) do
    find_antinodes(tail, bound_y, bound_x, head) ++ find_antinodes(tail, bound_y, bound_x)
  end

  defp find_antinodes([h | tail], bound_y, bound_x, head) do
    antinodes(head, h, bound_y, bound_x) ++ find_antinodes(tail, bound_y, bound_x, head)
  end

  def part1 do
    IO.puts("Day 08 part 1")
    {my, mx, antenna} = input()

    antenna
    |> Enum.map(fn {_, list} ->
      find_antinodes(list)
    end)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> Enum.filter(fn {y, x} ->
      in_bounds?({y, x}, my, mx)
    end)
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 08 part 2")
    {my, mx, antenna} = input()

    antenna
    |> Enum.map(fn {_, list} ->
      find_antinodes(list, my, mx)
    end)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> Enum.filter(fn {y, x} ->
      in_bounds?({y, x}, my, mx)
    end)
    |> Enum.count()
    |> IO.puts()
  end
end

Day08.part1()
Day08.part2()
