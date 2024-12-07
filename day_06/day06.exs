defmodule Day06 do
  defp input() do
    map =
      File.stream!("./input.txt")
      |> Stream.map(&String.trim(&1))
      |> Enum.map(&String.split(&1, "", trim: true))

    x = length(hd(map)) - 1
    y = length(map) - 1

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
      |> Enum.reduce(%{}, fn
        {y, x, "^"}, a -> Map.put(a, {y, x}, "^") |> Map.put(:guard, {y, x, "^"})
        {y, x, ">"}, a -> Map.put(a, {y, x}, ">") |> Map.put(:guard, {y, x, ">"})
        {y, x, "v"}, a -> Map.put(a, {y, x}, "v") |> Map.put(:guard, {y, x, "v"})
        {y, x, "<"}, a -> Map.put(a, {y, x}, "<") |> Map.put(:guard, {y, x, "<"})
        {y, x, v}, a -> Map.put(a, {y, x}, v)
      end)

    {y, x, map}
  end

  defp move_guard(map, count, max_y, max_x) do
    case map.guard do
      {y, x, "^"} when y - 1 < 0 ->
        {count + 1, Map.replace(map, {y, x}, "X")}

      {y, x, ">"} when x + 1 > max_x ->
        {count + 1, Map.replace(map, {y, x}, "X")}

      {y, x, "v"} when y + 1 > max_y ->
        {count + 1, Map.replace(map, {y, x}, "X")}

      {y, x, "<"} when x - 1 < 0 ->
        {count + 1, Map.replace(map, {y, x}, "X")}

      {y, x, "^"} ->
        case map[{y - 1, x}] do
          "#" ->
            map
            |> Map.replace({y, x}, ">")
            |> Map.replace(:guard, {y, x, ">"})
            |> move_guard(count, max_y, max_x)

          "." ->
            map
            |> Map.replace({y - 1, x}, "^")
            |> Map.replace(:guard, {y - 1, x, "^"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count + 1, max_y, max_x)

          _ ->
            map
            |> Map.replace({y - 1, x}, "^")
            |> Map.replace(:guard, {y - 1, x, "^"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count, max_y, max_x)
        end

      {y, x, ">"} ->
        case map[{y, x + 1}] do
          "#" ->
            map
            |> Map.replace({y, x}, "v")
            |> Map.replace(:guard, {y, x, "v"})
            |> move_guard(count, max_y, max_x)

          "." ->
            map
            |> Map.replace({y, x + 1}, ">")
            |> Map.replace(:guard, {y, x + 1, ">"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count + 1, max_y, max_x)

          _ ->
            map
            |> Map.replace({y, x + 1}, ">")
            |> Map.replace(:guard, {y, x + 1, ">"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count, max_y, max_x)
        end

      {y, x, "v"} ->
        case map[{y + 1, x}] do
          "#" ->
            map
            |> Map.replace({y, x}, "<")
            |> Map.replace(:guard, {y, x, "<"})
            |> move_guard(count, max_y, max_x)

          "." ->
            map
            |> Map.replace({y + 1, x}, "v")
            |> Map.replace(:guard, {y + 1, x, "v"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count + 1, max_y, max_x)

          _ ->
            map
            |> Map.replace({y + 1, x}, "v")
            |> Map.replace(:guard, {y + 1, x, "v"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count, max_y, max_x)
        end

      {y, x, "<"} ->
        case map[{y, x - 1}] do
          "#" ->
            map
            |> Map.replace({y, x}, "^")
            |> Map.replace(:guard, {y, x, "^"})
            |> move_guard(count, max_y, max_x)

          "." ->
            map
            |> Map.replace({y, x - 1}, "<")
            |> Map.replace(:guard, {y, x - 1, "<"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count + 1, max_y, max_x)

          _ ->
            map
            |> Map.replace({y, x - 1}, "<")
            |> Map.replace(:guard, {y, x - 1, "<"})
            |> Map.replace({y, x}, "X")
            |> move_guard(count, max_y, max_x)
        end
    end
  end

  defp obstruction_check(map, max_y, max_x, prev) do
    case map.guard do
      {y, _, "^"} when y - 1 < 0 ->
        {false, map}

      {_, x, ">"} when x + 1 > max_x ->
        {false, map}

      {y, _, "v"} when y + 1 > max_y ->
        {false, map}

      {_, x, "<"} when x - 1 < 0 ->
        {false, map}

      {y, x, "^"} ->
        case map[{y - 1, x}] do
          "#" ->
            if {y - 1, x, "^"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, ">")
              |> Map.replace(:guard, {y, x, ">"})
              |> obstruction_check(max_y, max_x, [{y - 1, x, "^"} | prev])
            end

          "O" ->
            if {y - 1, x, "^"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, ">")
              |> Map.replace(:guard, {y, x, ">"})
              |> obstruction_check(max_y, max_x, [{y - 1, x, "^"} | prev])
            end

          _ ->
            map
            |> Map.replace({y - 1, x}, "^")
            |> Map.replace(:guard, {y - 1, x, "^"})
            |> Map.replace({y, x}, "X")
            |> obstruction_check(max_y, max_x, prev)
        end

      {y, x, ">"} ->
        case map[{y, x + 1}] do
          "#" ->
            if {y, x + 1, ">"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "v")
              |> Map.replace(:guard, {y, x, "v"})
              |> obstruction_check(max_y, max_x, [{y, x + 1} | prev])
            end

          "O" ->
            if {y, x + 1, ">"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "v")
              |> Map.replace(:guard, {y, x, "v"})
              |> obstruction_check(max_y, max_x, [{y, x + 1} | prev])
            end

          _ ->
            map
            |> Map.replace({y, x + 1}, ">")
            |> Map.replace(:guard, {y, x + 1, ">"})
            |> Map.replace({y, x}, "X")
            |> obstruction_check(max_y, max_x, prev)
        end

      {y, x, "v"} ->
        case map[{y + 1, x}] do
          "#" ->
            if {y + 1, x, "v"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "<")
              |> Map.replace(:guard, {y, x, "<"})
              |> obstruction_check(max_y, max_x, [{y + 1, x, "v"} | prev])
            end

          "O" ->
            if {y + 1, x, "v"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "<")
              |> Map.replace(:guard, {y, x, "<"})
              |> obstruction_check(max_y, max_x, [{y + 1, x, "v"} | prev])
            end

          _ ->
            map
            |> Map.replace({y + 1, x}, "v")
            |> Map.replace(:guard, {y + 1, x, "v"})
            |> Map.replace({y, x}, "X")
            |> obstruction_check(max_y, max_x, prev)
        end

      {y, x, "<"} ->
        case map[{y, x - 1}] do
          "#" ->
            if {y, x - 1, "<"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "^")
              |> Map.replace(:guard, {y, x, "^"})
              |> obstruction_check(max_y, max_x, [{y, x - 1, "<"} | prev])
            end

          "O" ->
            if {y, x - 1, "<"} in prev do
              {true, map}
            else
              map
              |> Map.replace({y, x}, "^")
              |> Map.replace(:guard, {y, x, "^"})
              |> obstruction_check(max_y, max_x, [{y, x - 1, "<"} | prev])
            end

          _ ->
            map
            |> Map.replace({y, x - 1}, "<")
            |> Map.replace(:guard, {y, x - 1, "<"})
            |> Map.replace({y, x}, "X")
            |> obstruction_check(max_y, max_x, prev)
        end
    end
  end

  defp print_map(map, max_y, max_x) do
    0..max_y
    |> Enum.reduce("", fn y, a ->
      c =
        0..max_x
        |> Enum.reduce("", fn x, a -> a <> map[{y, x}] end)

      a <> "\n" <> c
    end)
    |> IO.puts()

    map
  end

  def part1 do
    IO.puts("Day 06 part 1")
    {max_y, max_x, map} = input()

    {count, _} = map |> move_guard(0, max_y, max_x)
    IO.puts(count)
  end

  def part2 do
    IO.puts("Day 06 part 2")
    {my, mx, map} = input()

    # print_map(map, my, mx)

    {_, nmap} = map |> move_guard(0, my, mx)
    {y, x, v} = map.guard

    nmap
    |> Map.replace(:guard, map.guard)
    |> Map.replace({y, x}, v)
    |> Enum.to_list()
    |> Stream.filter(fn
      {_, "X"} -> true
      _ -> false
    end)
    |> Stream.map(fn {pos, _} ->
      result = map |> Map.replace(pos, "O") |> obstruction_check(my, mx, [])

      case result do
        {true, _} -> 1
        {false, _} -> 0
      end
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day06.part1()
Day06.part2()
