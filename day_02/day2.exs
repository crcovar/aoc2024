defmodule Day2 do
  def read_input() do
    {:ok, file} = File.open("input.txt")

    reports =
      file
      |> IO.stream(:line)
      |> Enum.map(fn r ->
        String.split(r) |> Enum.map(&String.to_integer/1)
      end)

    File.close(file)

    reports
  end

  defp in_range?(distance) do
    distance >= 1 and distance <= 3
  end

  def safe?(report) when is_list(report) and length(report) > 1 do
    [f, s | rest] = report

    cond do
      f < s and in_range?(s - f) -> safe?([s | rest], :asc)
      f > s and in_range?(f - s) -> safe?([s | rest], :desc)
      true -> false
    end
  end

  defp safe?(report, direction) when is_list(report) and length(report) > 1 do
    [f, s | rest] = report

    case direction do
      :asc ->
        cond do
          f < s and in_range?(s - f) -> safe?([s | rest], direction)
          true -> false
        end

      :desc ->
        cond do
          f > s and in_range?(f - s) -> safe?([s | rest], direction)
          true -> false
        end
    end
  end

  defp safe?(r, _) when not is_list(r) or length(r) < 2 do
    true
  end

  defp dampen?(report) do
    0..(length(report) - 1)
    |> Enum.map(fn i ->
      List.delete_at(report, i)
    end)
    |> Enum.any?(&safe?/1)
  end

  def part1 do
    IO.puts("Part 1")
    reports = read_input()

    safe =
      reports
      |> Enum.reduce(0, fn c, a ->
        case safe?(c) do
          true -> a + 1
          false -> a
        end
      end)

    IO.puts(safe)
  end

  def part2 do
    IO.puts("Part 2")
    reports = read_input()

    safe =
      reports
      |> Enum.reduce(0, fn c, a ->
        # IO.inspect(c, charlists: :as_lists)

        if safe?(c) or dampen?(c) do
          a + 1
        else
          a
        end
      end)

    IO.puts(safe)
  end
end

Day2.part1()
Day2.part2()
