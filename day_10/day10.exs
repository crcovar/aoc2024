defmodule Day10 do
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
      |> Enum.flat_map(fn row ->
        {cols, y} = row

        cols
        |> Enum.map(fn col ->
          {v, x} = col
          {y, x, String.to_integer(v)}
        end)
      end)

    {y, x, map}
  end

  defp hike?(point, goal, input, checked, last \\ {0, 0, -1})
  defp hike?(point, _, _, _, last) when point == last, do: false
  defp hike?({_, _, h}, _, _, _, {_, _, l}) when h > l and h - l != 1, do: false
  defp hike?({_, _, h}, _, _, _, {_, _, l}) when l > h or l == h, do: false
  defp hike?({y, x, _}, _, {by, bx, _}, _, _) when y > by or y < 0 or x > bx or x < 0, do: false

  defp hike?(point, goal, _, _, _) when point == goal, do: true

  defp hike?({y, x, h}, goal, input, pid, _) do
    Agent.get(pid, & &1)
    checked = []

    if {y, x, h} in checked do
      false
    else
      # Agent.update(pid, fn state -> [{y, x, h}] ++ state end)

      {y1, y2, x1, x2} = {y + 1, y - 1, x + 1, x - 1}

      {_, _, map} = input

      map
      |> Enum.filter(fn
        {^y1, ^x, _} -> true
        {^y, ^x1, _} -> true
        {^y2, ^x, _} -> true
        {^y, ^x2, _} -> true
        _ -> false
      end)
      |> Enum.any?(&hike?(&1, goal, input, pid, {y, x, h}))
    end
  end

  defp hike_rating?(point, goal, input, last)
  defp hike_rating?(point, _, _, last) when point == last, do: 0
  defp hike_rating?({_, _, h}, _, _, {_, _, l}) when h > l and h - l != 1, do: 0
  defp hike_rating?({_, _, h}, _, _, {_, _, l}) when l > h or l == h, do: 0
  defp hike_rating?({y, x, _}, _, {by, bx, _}, _) when y > by or y < 0 or x > bx or x < 0, do: 0

  defp hike_rating?(point, goal, _, _) when point == goal, do: 1

  defp hike_rating?({y, x, h}, goal, input, _) do
    {y1, y2, x1, x2} = {y + 1, y - 1, x + 1, x - 1}

    {_, _, map} = input

    map
    |> Enum.filter(fn
      {^y1, ^x, _} -> true
      {^y, ^x1, _} -> true
      {^y2, ^x, _} -> true
      {^y, ^x2, _} -> true
      _ -> false
    end)
    |> Enum.reduce(0, fn c, a ->
      hike_rating?(c, goal, input, {y, x, h}) + a
    end)
  end

  def part1 do
    IO.puts("Day 10 part 1")
    {by, bx, map} = input()

    trailheads = map |> Enum.filter(fn {_, _, h} -> h == 0 end)
    peaks = map |> Enum.filter(fn {_, _, h} -> h == 9 end)

    trailheads
    |> Enum.map(fn th ->
      peaks
      |> Enum.map(fn pk ->
        {:ok, checked} = Agent.start_link(fn -> [] end)
        hike?(th, pk, {by, bx, map}, checked)
      end)
      |> Enum.count(& &1)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 10 part 2")
    {by, bx, map} = input()

    trailheads = map |> Enum.filter(fn {_, _, h} -> h == 0 end)
    peaks = map |> Enum.filter(fn {_, _, h} -> h == 9 end)

    trailheads
    |> Enum.map(fn th ->
      peaks
      |> Enum.map(fn pk ->
        hike_rating?(th, pk, {by, bx, map}, {0, 0, -1})
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day10.part1()
Day10.part2()
