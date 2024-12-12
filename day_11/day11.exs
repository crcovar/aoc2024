defmodule Day11 do
  defp get_input do
    File.stream!("./input.txt")
    |> Enum.reduce("", &(&2 <> String.trim(&1)))
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp blink(stone)
  defp blink(0), do: [1]

  defp blink(stone) when is_integer(stone) do
    case Integer.digits(stone) do
      s when rem(length(s), 2) == 0 ->
        s |> Enum.chunk_every(div(length(s), 2)) |> Enum.map(&Integer.undigits(&1))

      _ ->
        [stone * 2024]
    end
  end

  defp blink(dict) when is_map(dict) do
    dict
    |> Enum.reduce(%{}, fn
      {0, v}, a ->
        a |> Map.update(1, v, &(&1 + v))

      {k, v}, a ->
        case Integer.digits(k) do
          digits when rem(length(digits), 2) == 0 ->
            digits
            |> Enum.chunk_every(div(length(digits), 2))
            |> Enum.map(&Integer.undigits(&1))
            |> Enum.reduce(a, fn d, a -> Map.update(a, d, v, &(&1 + v)) end)

          _ ->
            Map.update(a, k * 2024, v, &(&1 + v))
        end
    end)
  end

  def part1 do
    IO.puts("Day 11 part 1")

    1..25
    |> Enum.reduce(get_input(), fn _, a ->
      a |> Enum.flat_map(&blink(&1))
    end)
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 11 part 2")
    input = get_input() |> Enum.frequencies()

    1..75
    |> Enum.reduce(input, fn _, a ->
      blink(a)
    end)
    |> Map.values()
    |> Enum.sum()
    |> IO.puts()
  end
end

Day11.part1()

Day11.part2()
