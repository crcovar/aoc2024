defmodule Day05 do
  defp split_and_parse(str, delim) do
    a = String.split(str, delim) |> Enum.map(&String.to_integer/1)

    case delim do
      "|" -> a |> List.to_tuple()
      _ -> a
    end
  end

  defp middle(list) do
    i = trunc(length(list) / 2)
    list |> Enum.at(i)
  end

  defp in_order?(update, _) when length(update) < 2, do: true

  defp in_order?(update, rules) do
    [head | tail] = update

    valid_rules =
      rules
      |> Enum.filter(fn
        {_, ^head} -> true
        _ -> false
      end)
      |> Enum.map(fn {x, _} -> x end)

    if valid_rules == [] do
      in_order?(tail, rules)
    else
      valid_rules
      |> Enum.reduce(true, fn c, a ->
        a and c not in tail
      end) and in_order?(tail, rules)
    end
  end

  def part1() do
    IO.puts("Day 05 part 1")

    printer =
      File.stream!("./input.txt")
      |> Stream.map(&String.trim(&1))
      |> Enum.reduce(%{:rules => [], :updates => []}, fn c, a ->
        cond do
          Regex.match?(~r/\d+\|\d+/, c) ->
            %{:rules => [split_and_parse(c, "|") | a[:rules]], :updates => a[:updates]}

          Regex.match?(~r/(\d+,?)+/, c) ->
            %{:rules => a[:rules], :updates => [split_and_parse(c, ",") | a[:updates]]}

          true ->
            a
        end
      end)

    printer[:updates]
    |> Enum.filter(fn u ->
      in_order?(u, printer[:rules])
    end)
    |> Enum.map(&middle(&1))
    |> Enum.sum()
    |> IO.puts()
  end

  def part2() do
    IO.puts("Day 05 part 2")
  end
end

Day05.part1()
Day05.part2()
