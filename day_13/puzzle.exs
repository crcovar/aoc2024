defmodule Day13 do
  def parse_machine(config) do
    [btn_a, btn_b, prize] = config

    btn_a =
      Regex.scan(~r/Button A: X\+(\d*), Y\+(\d*)/, btn_a, capture: :all_but_first)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    btn_b =
      Regex.scan(~r/Button B: X\+(\d*), Y\+(\d*)/, btn_b, capture: :all_but_first)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    prize =
      Regex.scan(~r/Prize: X=(\d*), Y=(\d*)/, prize, capture: :all_but_first)
      |> Enum.flat_map(& &1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    {btn_a, btn_b, prize}
  end

  def part1 do
    IO.puts("Day 13 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("example.txt")

    AoC.line_input(file)
    |> Enum.filter(&(&1 != ""))
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_machine/1)
    |> IO.inspect()
  end

  def part2 do
    IO.puts("Day 13 part 2")
  end
end

Day13.part1()
Day13.part2()
