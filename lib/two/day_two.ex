defmodule AdventOfCode.DayTwo do
  def part_one do
    [x, y] =
      parse_input("inputs/day-two.txt")
      |> Stream.map(&parse_position_input/1)
      |> Enum.reduce([0, 0], fn [x, y], [acc_x, acc_y] -> [acc_x + x, acc_y + y] end)

    x * y
  end

  def part_two do
    [_, x, y] =
      parse_input("inputs/day-two.txt")
      |> Enum.reduce([0, 0, 0], &reduce_with_aim/2)

    x * y
  end

  defp parse_position_input(command) do
    case command do
      ["forward", amount] -> [amount, 0]
      ["down", amount] -> [0, amount]
      ["up", amount] -> [0, amount * -1]
      _ -> [0, 0]
    end
  end

  defp reduce_with_aim(command, [aim, x, y]) do
    case command do
      ["forward", amount] ->
        [aim, x + amount, y + aim * amount]

      ["down", amount] ->
        [aim + amount, x, y]

      ["up", amount] ->
        [aim - amount, x, y]
    end
  end

  defp parse_input(path) do
    File.stream!(path)
    |> Stream.map(fn line -> String.trim_trailing(line, "\n") end)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [a, b] -> [a, String.to_integer(b)] end)
  end
end
