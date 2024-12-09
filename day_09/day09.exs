defmodule Day09 do
  require Integer

  defp get_input do
    File.stream!("./example.txt")
    |> Enum.reduce("", &(String.trim_trailing(&1) <> &2))
    |> String.split("", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index()
    |> Enum.map(& &1)
    |> Enum.map(fn
      {0, i} when Integer.is_odd(i) ->
        {".", [], 0}

      {b, i} when Integer.is_even(i) ->
        0..(b - 1)
        |> Enum.reduce({i, [], b}, fn _, {_, a, b} -> {div(i, 2), a ++ [div(i, 2)], b} end)

      {b, i} when Integer.is_odd(i) ->
        0..(b - 1) |> Enum.reduce({".", [], b}, fn _, {_, a, b} -> {".", a ++ ["."], b} end)
    end)
  end

  defp swap_free(list) do
    case list do
      ["." | tail] ->
        t = tail |> Enum.with_index() |> Enum.filter(fn {l, _} -> l != "." end) |> List.last()

        case t do
          nil -> list
          {v, i} -> [v] ++ swap_free(List.update_at(tail, i, fn _ -> "." end))
        end

      [h | tail] ->
        [h] ++ swap_free(tail)
    end
  end

  defp defrag(filesystem) do
    filesystem
  end

  defp checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.filter(fn {l, _} -> l != "." end)
    |> Enum.reduce(0, fn {n, i}, a -> n * i + a end)
  end

  def part1 do
    IO.puts("Day 09 part 1")

    get_input()
    |> Enum.flat_map(fn {_, l, _} -> l end)
    |> IO.inspect()
    |> swap_free()
    |> checksum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 09 part 2")

    get_input()
    |> IO.inspect()

    # get_input() |> defrag() |> checksum() |> IO.puts()
  end
end

Day09.part1()
Day09.part2()
