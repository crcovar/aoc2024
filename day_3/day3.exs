defmodule Day3 do
  def part1 do
    IO.puts("Day3 Part 1")
    regex = ~r/mul\((?<x>\d{1,3}),(?<y>\d{1,3})\)/

    File.stream!("./input.txt")
    |> Stream.map(&Regex.scan(regex, &1, capture: :all_names))
    |> Stream.flat_map(& &1)
    |> Stream.map(fn x ->
      Enum.reduce(x, 1, fn c, a -> String.to_integer(c) * a end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day3 Part 2")
    regex = ~r/(mul\((?<x>\d{1,3}),(?<y>\d{1,3})\))|(do\(\))|(don\'t\(\))/

    {:ok, go} = Agent.start_link(fn -> true end)

    File.stream!("./input.txt")
    |> Stream.map(&Regex.scan(regex, &1, capture: :all))
    |> Stream.flat_map(& &1)
    |> Stream.map(fn x ->
      case hd(x) do
        "do()" -> Agent.update(go, fn _ -> true end)
        "don't()" -> Agent.update(go, fn _ -> false end)
        _ -> nil
      end

      if Agent.get(go, & &1) and String.starts_with?(hd(x), "mul") do
        x |> Enum.slice(2, 2) |> Enum.reduce(1, fn c, a -> String.to_integer(c) * a end)
      else
        0
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day3.part1()
Day3.part2()
