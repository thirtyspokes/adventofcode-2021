defmodule AdventOfCode.DayThree do
  def part_one do
    ints = parse_input("inputs/day-three.txt")
    epsilon = most_common_bit(ints)
    gamma = Enum.map(epsilon, fn val -> if val == 0, do: 1, else: 0 end)

    binary_digits_to_decimal(epsilon) * binary_digits_to_decimal(gamma)
  end

  def part_two do
    bits = parse_input("inputs/day-three.txt")
    binary_digits_to_decimal(oxygen_rating(bits)) * binary_digits_to_decimal(co2_rating(bits))
  end

  @doc """
  Given a list of equal-length lists of binary digits, determines
  the most common bit at position n and filters out lists that do
  not have the most common bit at that position.

  The process then repeats for position n + 1, using the filtered lists until
  the result is only a single list.
  """
  def oxygen_rating(bits), do: do_oxygen_rating(bits, 0)

  defp do_oxygen_rating(bits, _i) when length(bits) == 1, do: hd(bits)

  defp do_oxygen_rating(bits, i) do
    nth_most_common = Enum.at(most_common_bit(bits), i)

    filtered_bits =
      Enum.filter(bits, fn bitstring -> Enum.at(bitstring, i) == nth_most_common end)

    do_oxygen_rating(filtered_bits, i + 1)
  end

  @doc """
  Performs the same algorithm as oxygen_rating/1, but uses the least
  most common bit at each position instead.
  """
  def co2_rating(bits), do: do_co2_rating(bits, 0)

  defp do_co2_rating(bits, _i) when length(bits) == 1, do: hd(bits)

  defp do_co2_rating(bits, i) do
    nth_least_common =
      most_common_bit(bits)
      |> Enum.map(fn val -> if val == 0, do: 1, else: 0 end)
      |> Enum.at(i)

    filtered_bits =
      Enum.filter(bits, fn bitstring -> Enum.at(bitstring, i) == nth_least_common end)

    do_co2_rating(filtered_bits, i + 1)
  end

  @doc """
  Given a list of lists where each element is a list of binary bits,
  determines the most common bit at each position.  If there is an
  equal number of 0s and 1s at a position, defaults to 1 as the most
  common bit.
  """
  defp most_common_bit(bits) do
    rotated = rotate(bits)

    rotated
    |> Enum.map(&Enum.sum/1)
    |> Enum.map(fn sum -> if sum >= length(hd(rotated)) / 2, do: 1, else: 0 end)
  end

  @doc """
  Given a 2-D matrix, rotate it such that:

  [[a1, a2, a3], [b1, b2, b3], [c1, c2, c3]]

  becomes:

  [[a1, b1, c1], [a2, b2, c2], [a3, b3, c3]]
  """
  defp rotate(ints) do
    len = length(hd(ints))

    for n <- 0..(len - 1) do
      Enum.map(ints, &Enum.at(&1, n))
    end
  end

  @doc """
  Convert a list of binary digits into its decimal representation.
  """
  defp binary_digits_to_decimal(digits) do
    Integer.undigits(digits, 2)
  end

  @doc """
  Parses the input file (binary digits represented as strings)
  into a list of lists of binary digits:

  "10101\n11111\n00000\n"

  becomes:

  [[1, 0, 1, 0, 1], [1, 1, 1, 1, 1], [0, 0, 0, 0, 0]]
  """
  defp parse_input(path) do
    File.stream!(path)
    |> Stream.map(fn line -> String.trim_trailing(line, "\n") end)
    |> Stream.map(fn line -> String.split(line, "", trim: true) end)
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
  end
end
