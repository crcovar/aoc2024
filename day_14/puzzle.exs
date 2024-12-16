defmodule Day14 do
  defp get_robots(line) do
    ~r/p=\d{1,3},\d{1,3} v=-?\d*,-?\d*/
  end

  def part1 do
    IO.puts("Day 14 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("example.txt")
    AoC.line_input(file) |> Enum.map(& &1) |> IO.inspect()
  end

  def part2 do
    IO.puts("Day 14 part 2")
  end
end

Day14.part1()
