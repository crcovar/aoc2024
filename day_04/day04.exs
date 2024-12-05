defmodule Day04 do
  defp check(row, count) do
    # check the row. if we have a match skip forward
    # otherwise check the next row
    if length(row) < 4 do
      count
    else
      w = Enum.take(row, 4)

      case w do
        ["X", "M", "A", "S"] -> check(Enum.drop(row, 3), count + 1)
        ["S", "A", "M", "X"] -> check(Enum.drop(row, 3), count + 1)
        _ -> check(tl(row), count)
      end
    end
  end

  defp xmas?(_, r2, _) when hd(tl(r2)) != "A", do: false

  defp xmas?(r1, _, r3) do
    a = [hd(r1), List.last(r1)]
    b = [hd(r3), List.last(r3)]

    regex = ~r/(M|S){2}/

    List.first(a) != List.last(b) and List.first(b) != List.last(a) and
      Regex.match?(regex, List.to_string(a)) and
      Regex.match?(regex, List.to_string(b))
  end

  defp diag(grid, i) do
    grid
    |> Enum.with_index(i)
    |> Enum.map(fn {row, index} -> Enum.at(row, index) end)
    |> Enum.filter(&(&1 != nil))
  end

  def part1 do
    IO.puts("Day 4 - Part 1")

    rows =
      File.stream!("./input.txt")
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Stream.map(fn r ->
        r |> Enum.filter(&(&1 != "\n"))
      end)

    columns = rows |> Stream.zip() |> Stream.map(&Tuple.to_list/1)

    l =
      0..(length(Enum.map(rows, & &1)) - 1)
      |> Enum.map(fn i ->
        rows |> diag(i)
      end)

    r =
      0..(length(Enum.map(rows, & &1)) - 1)
      |> Enum.map(fn i ->
        rows |> Enum.reverse() |> diag(i)
      end)

    x =
      0..length(Enum.map(rows, & &1))
      |> Enum.map(fn i ->
        rows |> Enum.map(&Enum.reverse(&1)) |> diag(i)
      end)

    y =
      0..length(Enum.map(rows, & &1))
      |> Enum.map(fn i ->
        rows
        |> Enum.reverse()
        |> Enum.map(&Enum.reverse(&1))
        |> diag(i)
      end)

    fr = rows |> Enum.reduce(0, &(check(&1, 0) + &2))
    fr = fr + (columns |> Enum.reduce(0, &(check(&1, 0) + &2)))
    fr = fr + (l |> Enum.reduce(0, &(check(&1, 0) + &2)))
    fr = fr + (r |> Enum.reduce(0, &(check(&1, 0) + &2)))
    fr = fr + (tl(x) |> Enum.reduce(0, &(check(&1, 0) + &2)))
    fr = fr + (tl(y) |> Enum.reduce(0, &(check(&1, 0) + &2)))
    IO.puts(fr)
  end

  def part2 do
    IO.puts("Day 4 - Part 2")

    rows =
      File.stream!("./input.txt")
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn r ->
        r |> Enum.filter(&(&1 != "\n"))
      end)

    numCols = length(hd(rows))

    # for each row. run through and check regex if match check 2 rows below it.
    0..(length(rows) - 3)
    |> Enum.reduce(0, fn rIdx, a ->
      # get 3 rows
      [x, y, z] = rows |> Enum.slice(rIdx, 3)
      # run through the rows and check the regex
      0..(numCols - 3)
      |> Enum.reduce(a, fn i, a ->
        r1 = x |> Enum.slice(i, 3)
        r2 = y |> Enum.slice(i, 3)
        r3 = z |> Enum.slice(i, 3)

        if xmas?(r1, r2, r3) do
          a + 1
        else
          a
        end
      end)
    end)
    |> IO.puts()
  end
end

Day04.part1()
Day04.part2()
