defmodule Day17 do
  def parse_input(line, registers) when is_pid(registers) do
    regex = ~r/Register ([A|B|C]): (\d+)/

    cond do
      String.starts_with?(line, "Register") ->
        Regex.scan(regex, line, capture: :all_but_first)
        |> hd()
        |> then(fn [reg, val] -> set_register(registers, reg, String.to_integer(val)) end)

      String.starts_with?(line, "Program") ->
        line
        |> String.split(": ")
        |> tl()
        |> hd()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      true ->
        nil
    end
  end

  def parse_input(line, prog) when is_map(prog) do
    cond do
      String.starts_with?(line, "Register") ->
        ~r/Register ([A|B|C]): (\d+)/
        |> Regex.scan(line, capture: :all_but_first)
        |> hd()
        |> then(fn [reg, val] -> prog |> Map.put(String.to_atom(reg), String.to_integer(val)) end)

      String.starts_with?(line, "Program") ->
        instructions =
          line
          |> String.split(": ")
          |> tl()
          |> hd()
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)

        prog |> Map.put(:instructions, instructions) |> Map.put(:size, length(instructions))

      true ->
        prog
    end
  end

  defp set_register(pid, reg, val) do
    Agent.update(pid, fn state ->
      state |> Map.put(reg, val)
    end)
  end

  defp combo(prog, operand)

  defp combo(_, operand)
       when operand == 0
       when operand == 1
       when operand == 2
       when operand == 3 do
    operand
  end

  defp combo(prog, 4), do: prog[:A]
  defp combo(prog, 5), do: prog[:B]
  defp combo(prog, 6), do: prog[:C]

  defp adv(prog, operand) do
    op = combo(prog, operand)
    result = div(prog[:A], 2 ** op)
    prog |> Map.put(:A, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp bxl(prog, operand) do
    result = Bitwise.bxor(prog[:B], operand)
    prog |> Map.put(:B, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp bst(prog, operand) do
    operand = combo(prog, operand)
    result = rem(operand, 8)
    prog |> Map.put(:B, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp jnz(prog, operand) do
    unless prog[:A] == 0 do
      prog |> Map.put(:ip, operand)
    else
      prog |> Map.update!(:ip, &(&1 + 2))
    end
  end

  defp bxc(prog, _) do
    result = Bitwise.bxor(prog[:B], prog[:C])
    prog |> Map.put(:B, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp out(prog, operand) do
    operand = combo(prog, operand)
    result = rem(operand, 8)
    prog |> Map.update!(:out, &[result | &1]) |> Map.update!(:ip, &(&1 + 2))
  end

  defp bdv(prog, operand) do
    op = combo(prog, operand)
    result = div(prog[:A], 2 ** op)
    prog |> Map.put(:B, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp cdv(prog, operand) do
    op = combo(prog, operand)
    result = div(prog[:A], 2 ** op)
    prog |> Map.put(:C, result) |> Map.update!(:ip, &(&1 + 2))
  end

  defp run_program(prog) do
    unless prog[:ip] >= prog[:size] - 1 do
      prog[:instructions]
      |> Enum.drop(prog[:ip])
      |> Enum.take(2)
      |> then(fn
        [0, operand] -> adv(prog, operand)
        [1, operand] -> bxl(prog, operand)
        [2, operand] -> bst(prog, operand)
        [3, operand] -> jnz(prog, operand)
        [4, operand] -> bxc(prog, operand)
        [5, operand] -> out(prog, operand)
        [6, operand] -> bdv(prog, operand)
        [7, operand] -> cdv(prog, operand)
      end)
      |> run_program()
    else
      prog
    end
  end

  def part1 do
    IO.puts("#{__MODULE__} part 2")
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")

    AoC.line_input(file)
    |> Enum.reduce(%{:ip => 0, :out => []}, &parse_input(&1, &2))
    |> run_program()
    |> then(fn prog -> prog[:out] |> Enum.reverse() |> Enum.join(",") end)
    |> IO.puts()
  end

  def part2 do
    IO.puts("#{__MODULE__} part 2")
    file = __ENV__.file |> Path.dirname() |> Path.join("input.txt")

    prog =
      AoC.line_input(file)
      |> Enum.reduce(%{:ip => 0, :out => []}, &parse_input(&1, &2))

    IO.puts(prog[:A])

    42_949_672_953..4_294_967_295
    |> Enum.find(fn a ->
      IO.write("\r#{a}")
      prog = prog |> Map.put(:A, a)
      prog |> run_program() |> then(&(Enum.reverse(&1[:out]) == &1[:instructions]))
    end)
    |> IO.puts()
  end
end

Day17.part1()
Day17.part2()
