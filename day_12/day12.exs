defmodule Day12 do
  defp get_perimeter({y, x}, region) do
    # :bottm, :top, :right, :left
    [{y + 1, x}, {y - 1, x}, {y, x + 1}, {y, x - 1}]
    |> Enum.map(&if &1 not in region, do: 1, else: 0)
  end

  defp get_sides({y, x}, region) do
    bucket_check = fn
      point, region, :top ->
        case get_perimeter(point, region) do
          [0, 1, 0, 0] -> 2
          [0, 1, 1, 0] -> 1
          [0, 1, 0, 1] -> 1
          [0, 0, 1, 0] -> 1
          [0, 0, 0, 1] -> 1
          _ -> 0
        end

      point, region, :bottom ->
        case get_perimeter(point, region) do
          [1, 0, 0, 0] -> 2
          [1, 0, 1, 0] -> 1
          [1, 0, 0, 1] -> 1
          [0, 0, 1, 0] -> 1
          [0, 0, 0, 1] -> 1
          _ -> 0
        end

      point, region, :left ->
        case get_perimeter(point, region) do
          [0, 0, 0, 1] -> 2
          [1, 0, 0, 1] -> 1
          [0, 1, 0, 1] -> 1
          [1, 0, 0, 0] -> 1
          [0, 1, 0, 0] -> 1
          _ -> 0
        end

      point, region, :right ->
        case get_perimeter(point, region) do
          [0, 0, 1, 0] -> 2
          [1, 0, 1, 0] -> 1
          [0, 1, 1, 0] -> 1
          [1, 0, 0, 0] -> 1
          [0, 1, 0, 0] -> 1
          _ -> 0
        end
    end

    line_check = fn
      point, region, :bottom ->
        case get_perimeter(point, region) do
          [0, 0, 1, 1] -> 2
          _ -> 0
        end

      point, region, :top ->
        case get_perimeter(point, region) do
          _ -> 0
        end

      point, region, :right ->
        case get_perimeter(point, region) do
          _ -> 0
        end

      point, region, :left ->
        case get_perimeter(point, region) do
          _ -> 0
        end
    end

    case get_perimeter({y, x}, region) do
      # bottom-right
      [1, 0, 1, 0] -> 1
      # bottom-left
      [1, 0, 0, 1] -> 1
      # top-rgit
      [0, 1, 1, 0] -> 1
      # top-left
      [0, 1, 0, 1] -> 1
      # no corners
      [0, 0, 0, 0] -> 0
      # top and bottom no corners
      [1, 1, 0, 0] -> 0
      # left and right no corners
      [0, 0, 1, 1] -> 0
      # 4 corners
      [1, 1, 1, 1] -> 4
      # top right bottom
      [1, 1, 1, 0] -> 2 + bucket_check.({y, x - 1}, region, :left)
      # bottom left top
      [1, 1, 0, 1] -> 2 + bucket_check.({y, x + 1}, region, :right)
      # right bottom left
      [1, 0, 1, 1] -> 2 + bucket_check.({y - 1, x}, region, :top)
      # left top right
      [0, 1, 1, 1] -> 2 + bucket_check.({y + 1, x}, region, :bottom)
    end
  end

  defp make_regions(plots, pid, regions \\ [])
  defp make_regions([], _, regions), do: regions

  defp make_regions([head | tail], pid, regions) do
    r =
      tail
      |> add_plots(head, pid)

    tail = tail |> Enum.filter(&(&1 not in r))

    make_regions(tail, pid, regions ++ [r])
  end

  defp add_plots(plots, {y, x}, pid) do
    checked = Agent.get(pid, & &1)

    if {y, x} in checked do
      []
    else
      Agent.update(pid, fn s -> [{y, x}] ++ s end)
      # Get all the next steps that are in our plots
      next =
        [{y + 1, x}, {y - 1, x}, {y, x + 1}, {y, x - 1}]
        |> Enum.filter(&(&1 in plots))

      plots = plots |> Enum.filter(&(&1 not in next))

      next =
        next
        |> Enum.flat_map(fn p ->
          add_plots(plots, p, pid)
        end)

      [{y, x}] ++ next
    end
  end

  def part1 do
    IO.puts("Day 12 part 1")
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")
    {_, _, grid} = AoC.grid_input(file)

    grid
    |> Enum.group_by(fn {_, _, crop} -> crop end, fn {y, x, _} -> {y, x} end)
    |> Map.values()
    |> Task.async_stream(
      fn v ->
        {:ok, pid} = Agent.start_link(fn -> [] end)

        make_regions(v, pid)
        |> Task.async_stream(
          fn region ->
            area = length(region)

            perimeter =
              region
              |> Enum.reduce(0, fn c, a ->
                perimeter = get_perimeter(c, region) |> Enum.sum()
                a + perimeter
              end)

            IO.puts("area #{area} perimeter #{perimeter} cost #{area * perimeter}")
            area * perimeter
          end,
          ordered: false
        )
        |> Enum.map(fn {_, v} -> v end)
      end,
      ordered: false
    )
    |> Enum.flat_map(fn {_, v} -> v end)
    |> IO.inspect()
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 12 part 2")
  end
end

Day12.part1()
Day12.part2()
