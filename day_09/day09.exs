defmodule Day09 do
  defp get_input do
    File.stream!("./input.txt")
    |> Enum.reduce("", &(String.trim_trailing(&1) <> &2))
    |> String.split("", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Stream.with_index()
    |> Enum.map(fn
      {[b], i} ->
        0..(b - 1) |> Enum.reduce([], fn _, a -> [a, Integer.to_string(i)] end)

      {[b, 0], i} ->
        0..(b - 1) |> Enum.reduce([], fn _, a -> [a, Integer.to_string(i)] end)

      {[b, f], i} ->
        out = 0..(b - 1) |> Enum.reduce([], fn _, a -> [a, Integer.to_string(i)] end)
        0..(f - 1) |> Enum.reduce(out, fn _, a -> [a, "."] end)
    end)
    |> List.flatten()
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

  defp checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.filter(fn {l, _} -> l != "." end)
    |> Enum.map(fn {n, i} -> {String.to_integer(n), i} end)
    |> Enum.reduce(0, fn {n, i}, a -> n * i + a end)
  end

  def part1 do
    IO.puts("Day 09 part 1")
    get_input() |> swap_free() |> checksum() |> IO.puts()
  end

  def part2 do
    IO.puts("Day 09 part 2")
  end
end

Day09.part1()
Day09.part2()
