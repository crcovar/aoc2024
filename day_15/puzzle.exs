defmodule Day15 do
  defp move(dir, grid, item)

  def part1 do
    IO.puts("Day 15 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("example.txt")
    input = AoC.line_input(file) |> Enum.group_by(&String.starts_with?(&1, "#"))

    {_, _, grid} = input[true] |> Enum.map(&String.split(&1, "")) |> AoC.make_grid()

    robot =
      grid
      |> Enum.find(fn
        {_, _, "@"} -> true
        _ -> false
      end)

    instructions = input[false] |> Enum.join() |> String.split("", trim: true)
  end

  def part2 do
    IO.puts("Day 15 part 2")
  end
end

Day15.part1()
