defmodule Day1 do
  def read_input() do
    # Read the input file
    {:ok, file} = File.open("input.txt", [:read])

    # Split the input by new line
    lines = IO.stream(file, :line) |> Enum.map(&String.trim/1)

    left =
      lines
      |> Enum.map(fn l -> hd(String.split(l)) end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(:asc)

    right =
      lines
      |> Enum.map(fn l -> List.last(String.split(l)) end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort(:asc)

    File.close(file)

    {left, right}
  end

  def diff([l | ltail], [r | rtail]) do
    cond do
      l >= r -> l - r + diff(ltail, rtail)
      l < r -> r - l + diff(ltail, rtail)
    end
  end

  def diff([], []) do
    0
  end

  def part1 do
    IO.puts("Part 1")
    {left, right} = read_input()

    # run our diff
    IO.puts(diff(left, right))
  end

  def part2 do
    IO.puts("Part 2")
    {left, right} = read_input()

    similarities =
      left
      |> Enum.map(fn l ->
        m = right |> Enum.filter(&match?(^l, &1)) |> length

        case m do
          0 -> 0
          _ -> l * m
        end
      end)
      |> Enum.sum()

    IO.puts(similarities)
  end
end

Day1.part1()
Day1.part2()
