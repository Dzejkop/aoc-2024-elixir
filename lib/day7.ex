defmodule Day7 do
  def parse_input(content) do
    content
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    {total, ": " <> rest} = Integer.parse(line)

    nums =
      rest
      |> String.split(" ")
      |> Enum.map(&String.trim/1)
      # just in case
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))

    {total, nums}
  end

  def part_one(f) do
    content = File.read!(f)
    data = parse_input(content)

    solve(data)
  end

  def solve(data) do
    data |> Enum.map(&eval_line/1) |> Enum.sum()
  end

  def eval_line({total, operands}) do
    if all_sums(operands) |> Enum.any?(&(&1 == total)) do
      total
    else
      0
    end
  end

  def all_sums([x | xs]) do
    all_sums_inner(x, xs)
  end

  def all_sums_inner(s, [x | xs]) do
    Enum.concat(
      all_sums_inner(s + x, xs),
      all_sums_inner(s * x, xs)
    )
  end

  def all_sums_inner(s, []) do
    [s]
  end
end
