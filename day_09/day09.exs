defmodule Day09 do
  require Integer

  defp get_input do
    File.stream!("./input.txt")
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
        |> Enum.reduce({i, [], b}, fn _, {_, a, b} ->
          {div(i, 2), a ++ [div(i, 2)], b}
        end)

      {b, i} when Integer.is_odd(i) ->
        0..(b - 1)
        |> Enum.reduce({".", [], b}, fn _, {_, a, b} -> {".", a ++ ["."], b} end)
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

  defp place_file({".", _, free, free_idx}, {v, file, size, idx}) do
    [{v, file, size, idx}, {".", nil, free - size, free_idx}]
  end

  defp place_file(nil, _), do: nil

  defp defrag(filesystem) do
    filesystem
    |> Enum.filter(fn {v, _, _} -> v != "." end)
    |> Enum.reverse()
    # for each file find first possible space. if found place new item there, remove it from list
    |> Enum.reduce(filesystem, fn {v, file, s}, fs ->
      fs |> defrag({v, file, s}) |> List.flatten()
    end)
  end

  defp defrag(filesystem, file, did_defrag \\ false)

  defp defrag([], _, _), do: []

  defp defrag([{a, blocks, size} | tail], {b, _, _}, false) when a == b,
    do: [{a, blocks, size}, tail]

  defp defrag([{".", f, free} | tail], {v, l, file}, false) do
    remaining = free - file
    # IO.puts("Finding space for #{v} found #{free} free blocks with #{remaining} remaining")

    cond do
      remaining > 0 ->
        [{v, l, file}, {".", Enum.take(f, remaining), remaining}] ++
          defrag(tail, {v, l, file}, true)

      remaining == 0 ->
        [{v, l, file}] ++ defrag(tail, {v, l, file}, true)

      remaining < 0 ->
        [{".", f, free}] ++ defrag(tail, {v, l, file}, false)
    end
  end

  defp defrag([{a, blocks, size} | tail], {b, l, s}, did_defrag) when a != b,
    do: [{a, blocks, size}] ++ defrag(tail, {b, l, s}, did_defrag)

  defp defrag([{a, blocks, size} | tail], {b, _, _}, true) when a == b,
    do: [{".", Enum.map(blocks, fn _ -> "." end), size}] ++ tail

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
    |> swap_free()
    |> checksum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 09 part 2")

    get_input()
    |> defrag()
    |> Enum.flat_map(fn {_, l, _} -> l end)
    |> checksum()
    |> IO.puts()
  end
end

# Day09.part1()
Day09.part2()
