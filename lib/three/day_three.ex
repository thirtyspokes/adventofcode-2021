defmodule AdventOfCode.DayThree do
  def part_one do
    ints = parse_input("inputs/day-three.txt")
    epsilon = most_common_bit(ints)
    gamma = Enum.map(epsilon, fn (val) -> if val == 0, do: 1, else: 0 end)

    (binary_digits_to_decimal(epsilon) * binary_digits_to_decimal(gamma))
  end

  def part_two do
    bits = parse_input("inputs/day-three.txt")
    (binary_digits_to_decimal(oxygen_rating(bits)) * binary_digits_to_decimal(co2_rating(bits)))
  end

  defp oxygen_rating(bits) do
    do_oxygen_rating(bits, 0)
  end

  defp do_oxygen_rating(bits, _i) when length(bits) == 1, do: hd(bits)
  defp do_oxygen_rating(bits, i) do
    nth_most_common = Enum.at(most_common_bit(bits), i)
    filtered_bits = Enum.filter(bits, fn (bitstring) -> Enum.at(bitstring, i) == nth_most_common end)
    do_oxygen_rating(filtered_bits, i + 1)
  end

  defp co2_rating(bits) do
    do_co2_rating(bits, 0)
  end

  defp do_co2_rating(bits, _i) when length(bits) == 1, do: hd(bits)
  defp do_co2_rating(bits, i) do
    nth_least_common = most_common_bit(bits)
    |> Enum.map(fn (val) -> if val == 0, do: 1, else: 0 end)
    |> Enum.at(i)

    filtered_bits = Enum.filter(bits, fn (bitstring) -> Enum.at(bitstring, i) == nth_least_common end)
    do_co2_rating(filtered_bits, i + 1)
  end

  defp most_common_bit(bits) do
    rotated = rotate(bits)

    rotated
    |> Enum.map(&Enum.sum/1)
    |> Enum.map(fn (sum) -> if sum >= (length(hd(rotated)) / 2), do: 1, else: 0 end)
  end

  defp rotate(ints) do
    len = length(hd(ints))

    for n <- 0..(len - 1) do
      Enum.map(ints, &(Enum.at(&1, n)))
    end
  end

  defp binary_digits_to_decimal(digits) do
    Integer.undigits(digits, 2)
  end

  defp parse_input(path) do
    File.stream!(path)
    |> Stream.map(fn (line) -> String.trim_trailing(line, "\n") end)
    |> Stream.map(fn (line) -> String.split(line, "", trim: true) end)
    |> Enum.map(fn (line) -> Enum.map(line, &String.to_integer/1) end)
  end
end
