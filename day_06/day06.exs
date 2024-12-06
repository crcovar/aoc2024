defmodule Day06 do
  defp input() do
    File.stream!("./input.txt")
    |> Stream.map(&String.trim(&1))
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp move_guard(count, map, max_x, max_y) do
    case map.guard do
      {y, x, "^"} ->
        if y - 1 < 0 do
          # we're done
          {count + 1, map}
        else
          case map[{y - 1, x}] do
            "#" ->
              m = map |> Map.replace({y, x}, ">") |> Map.replace(:guard, {y, x, ">"})
              move_guard(count, m, max_x, max_y)

            "." ->
              m =
                map
                |> Map.replace({y - 1, x}, "^")
                |> Map.replace(:guard, {y - 1, x, "^"})
                |> Map.replace({y, x}, "X")

              move_guard(count + 1, m, max_x, max_y)

            _ ->
              m =
                map
                |> Map.replace({y - 1, x}, "^")
                |> Map.replace(:guard, {y - 1, x, "^"})

              move_guard(count, m, max_x, max_y)
          end
        end

      {y, x, ">"} ->
        if x + 1 > max_x do
          # we're done
          {count + 1, map}
        else
          case map[{y, x + 1}] do
            "#" ->
              m = map |> Map.replace({y, x}, "v") |> Map.replace(:guard, {y, x, "v"})
              move_guard(count, m, max_x, max_y)

            "." ->
              m =
                map
                |> Map.replace({y, x + 1}, ">")
                |> Map.replace(:guard, {y, x + 1, ">"})
                |> Map.replace({y, x}, "X")

              move_guard(count + 1, m, max_x, max_y)

            _ ->
              m =
                map
                |> Map.replace({y, x + 1}, ">")
                |> Map.replace(:guard, {y, x + 1, ">"})

              move_guard(count, m, max_x, max_y)
          end
        end

      {y, x, "v"} ->
        if y + 1 > max_y do
          # we're done
          {count + 1, map}
        else
          case map[{y + 1, x}] do
            "#" ->
              m = map |> Map.replace({y, x}, "<") |> Map.replace(:guard, {y, x, "<"})
              move_guard(count, m, max_x, max_y)

            "." ->
              m =
                map
                |> Map.replace({y + 1, x}, "v")
                |> Map.replace(:guard, {y + 1, x, "v"})
                |> Map.replace({y, x}, "X")

              move_guard(count + 1, m, max_x, max_y)

            _ ->
              m =
                map
                |> Map.replace({y + 1, x}, "v")
                |> Map.replace(:guard, {y + 1, x, "v"})

              move_guard(count, m, max_x, max_y)
          end
        end

      {y, x, "<"} ->
        if x - 1 < 0 do
          # we're done
          {count + 1, map}
        else
          case map[{y, x - 1}] do
            "#" ->
              m = map |> Map.replace({y, x}, "^") |> Map.replace(:guard, {y, x, "^"})
              move_guard(count, m, max_x, max_y)

            "." ->
              m =
                map
                |> Map.replace({y, x - 1}, "<")
                |> Map.replace(:guard, {y, x - 1, "<"})
                |> Map.replace({y, x}, "X")

              move_guard(count + 1, m, max_x, max_y)

            _ ->
              m =
                map
                |> Map.replace({y, x - 1}, "<")
                |> Map.replace(:guard, {y, x - 1, "<"})

              move_guard(count, m, max_x, max_y)
          end
        end
    end
  end

  def part1 do
    IO.puts("Day 06 part 1")
    map = input()

    max_x = length(hd(map)) - 1
    max_y = length(map) - 1

    map =
      map
      |> Enum.map(&Enum.with_index(&1))
      |> Enum.with_index()
      |> Enum.flat_map(fn row ->
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

    {count, _} = move_guard(0, map, max_x, max_y)
    IO.puts(count)
  end

  def part2 do
    IO.puts("Day 06 part 2")
  end
end

Day06.part1()
Day06.part2()
