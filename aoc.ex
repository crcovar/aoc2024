defmodule AoC do
  def line_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim(&1))
  end

  def grid_input(filename) do
    grid =
      line_input(filename)
      |> Enum.map(&String.split(&1, "", trim: true))

    x = length(hd(grid)) - 1
    y = length(grid) - 1

    grid =
      grid
      |> Stream.map(&Enum.with_index(&1))
      |> Stream.with_index()
      |> Enum.flat_map(fn row ->
        {cols, y} = row

        cols
        |> Enum.map(fn col ->
          {v, x} = col
          {y, x, v}
        end)
      end)

    {y, x, grid}
  end
end
