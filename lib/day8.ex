defmodule Day8 do
  def part_one(f) do
    content = File.read!(f)
    data = parse_input(content)
    solve(data)
  end

  def parse_input(content) do
    chars =
      content
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.codepoints/1)

    h = length(chars)
    w = length(Enum.at(chars, 0))

    rows = Stream.with_index(chars)

    indexed =
      rows
      |> Enum.flat_map(fn {row, y} ->
        Enum.with_index(row)
        |> Enum.map(fn {i, x} ->
          {i, {x, y}}
        end)
      end)

    positions =
      indexed
      |> Enum.reduce(%{}, fn {c, pos}, acc ->
        if c != "." do
          case Map.get(acc, c) do
            nil -> Map.put(acc, c, [pos])
            lst -> Map.put(acc, c, [pos | lst])
          end
        else
          acc
        end
      end)

    {{w, h}, positions}
  end

  def solve({bounds, data}) do
    antinodes =
      Enum.reduce(data, MapSet.new(), fn {_k, vs}, set ->
        MapSet.union(set, antinodes(bounds, vs))
      end)

    MapSet.size(antinodes)
  end

  def antinodes(bounds, antennas) do
    all_pairs(antennas)
    |> Enum.flat_map(&pair_antinodes(bounds, &1))
    |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))
  end

  def pair_antinodes(bounds, {a, b}) do
    a1 = V.add(a, V.sub(a, b))
    a2 = V.add(b, V.sub(b, a))

    [a1, a2]
    |> Enum.filter(&bound_check(bounds, &1))
  end

  def bound_check({w, h}, {x, y}) do
    x >= 0 and x < w and y >= 0 and y < h
  end

  def all_pairs([x | xs]) do
    x_pairs = for y <- xs, do: {x, y}
    Enum.concat(x_pairs, all_pairs(xs))
  end

  def all_pairs([]) do
    []
  end
end
