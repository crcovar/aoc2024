defmodule Day07 do
  defp read_input do
    File.stream!("./input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(fn s ->
        s |> String.trim_trailing(":") |> String.to_integer()
      end)
    end)
    |> Stream.map(&%{:result => hd(&1), :eq => tl(&1)})
  end

  @doc """
    Check to see if a given set of values can be made into a valid operation by
    multiplying and adding sets of 2 at a time.

    `eq` is a list of values
    `goal` is the final number we're looking for
    `result` is the current result we have so far

  """
  def fixable?(eq, goal, result \\ 0)
  def fixable?([], goal, result), do: result == goal
  def fixable?(_, goal, result) when result > goal, do: false
  def fixable?(eq, goal, 0), do: fixable?(tl(eq), goal, hd(eq))

  def fixable?(eq, goal, result) do
    [head | tail] = eq
    fixable?(tail, goal, result + head) or fixable?(tail, goal, result * head)
  end

  def fixable_concat?(eq, goal, result \\ 0)
  def fixable_concat?([], goal, result), do: result == goal
  def fixable_concat?(_, goal, result) when result > goal, do: false
  def fixable_concat?(eq, goal, 0), do: fixable_concat?(tl(eq), goal, hd(eq))

  def fixable_concat?(eq, goal, result) do
    [head | tail] = eq
    concat = (Integer.to_string(result) <> Integer.to_string(head)) |> String.to_integer()

    fixable_concat?(tail, goal, result + head) or fixable_concat?(tail, goal, result * head) or
      fixable_concat?(tail, goal, concat)
  end

  def part1 do
    IO.puts("Day 07 part 1")

    read_input()
    |> Stream.filter(&fixable?(&1.eq, &1.result))
    |> Stream.map(& &1.result)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 07 part 2")

    read_input()
    |> Stream.filter(&fixable_concat?(&1.eq, &1.result))
    |> Stream.map(& &1.result)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day07.part1()
Day07.part2()
