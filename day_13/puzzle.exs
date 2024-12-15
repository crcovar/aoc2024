defmodule Day13 do
  defp parse_machine(config) do
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

  defp solve(presses, machine)

  defp solve({a, _}, _) when a > 99, do: nil
  defp solve({_, b}, _) when b > 99, do: nil
  defp solve({a, b}, {{ax, _}, {bx, _}, {px, _}}) when a * ax + b * bx > px, do: nil
  defp solve({a, b}, {{_, ay}, {_, by}, {_, py}}) when a * ay + b * by > py, do: nil

  defp solve({a, b}, prize) do
    {{ax, ay}, {bx, by}, {px, py}} = prize

    if a * ax + b * bx == px and a * ay + b * by == py do
      {a, b}
    else
      solve({a, b + 1}, prize)
    end
  end

  def part1 do
    IO.puts("Day 13 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")

    AoC.line_input(file)
    |> Enum.filter(&(&1 != ""))
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_machine/1)
    |> Enum.map(fn machine ->
      0..99
      |> Enum.find_value(&solve({&1, 0}, machine))
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.reduce(0, fn {a, b}, acc -> a * 3 + b + acc end)
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 13 part 2")
  end
end

Day13.part1()
Day13.part2()
