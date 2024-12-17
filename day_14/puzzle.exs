defmodule Day14 do
  defp get_robots(line) do
    ~r/p=(\d{1,3},\d{1,3}) v=(-?\d*,-?\d*)/
    |> Regex.scan(line, capture: :all_but_first)
    |> Enum.flat_map(& &1)
    |> Enum.map(fn x ->
      x |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  defp boundry_check(position, w, h)
  defp boundry_check({px, py}, w, h) when px >= w, do: boundry_check({px - w, py}, w, h)
  defp boundry_check({px, py}, w, h) when px < 0, do: boundry_check({px + w, py}, w, h)
  defp boundry_check({px, py}, w, h) when py >= h, do: boundry_check({px, py - h}, w, h)
  defp boundry_check({px, py}, w, h) when py < 0, do: boundry_check({px, py + h}, w, h)
  defp boundry_check(position, _, _), do: position

  defp move(seconds, position, velocity, w, h)
  defp move(seconds, position, _, _, _) when seconds == 0, do: position

  defp move(seconds, {px, py}, {vx, vy}, w, h) do
    move(seconds - 1, boundry_check({px + vx, py + vy}, w, h), {vx, vy}, w, h)
  end

  def part1 do
    IO.puts("Day 14 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")

    width = 101
    height = 103

    AoC.line_input(file)
    |> Enum.map(& &1)
    |> Enum.map(&get_robots/1)
    |> Enum.map(&List.to_tuple/1)
    |> Stream.map(fn {position, velocity} ->
      move(100, position, velocity, width, height)
    end)
    |> Enum.group_by(fn
      {x, y} when x < div(width, 2) and y < div(height, 2) -> 1
      {x, y} when x > div(width, 2) and y < div(height, 2) -> 2
      {x, y} when x < div(width, 2) and y > div(height, 2) -> 3
      {x, y} when x > div(width, 2) and y > div(height, 2) -> 4
      _ -> nil
    end)
    |> Enum.filter(fn {k, _} -> k != nil end)
    |> Enum.map(fn {_, v} ->
      v |> Enum.frequencies() |> Map.values() |> Enum.sum()
    end)
    |> Enum.reduce(1, &(&1 * &2))
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 14 part 2")
  end
end

Day14.part1()
