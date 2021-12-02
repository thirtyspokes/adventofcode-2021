defmodule AdventOfCode.DayOne do
  def part_one do
    parse_input("inputs/day-one.txt")
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn ([a, b]) -> if a < b, do: 1, else: 0 end)
    |> Enum.sum
  end

  def part_two do
    parse_input("inputs/day-one.txt")
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&Enum.sum/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn ([a, b]) -> if a < b, do: 1, else: 0 end)
    |> Enum.sum
  end

  defp parse_input(path) do
    File.stream!(path)
    |> Stream.map(fn (line) -> String.trim_trailing(line, "\n") end)
    |> Stream.map(&String.to_integer/1)
  end
end
