defmodule GridMap do
  defstruct size: {0, 0}, map: nil

  def parse(s, parser \\ &Function.identity/1) do
    rows =
      String.split(s, "\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.codepoints/1)

    h = length(rows)
    w = length(Enum.at(rows, 0))

    items = rows |> Enum.flat_map(&Function.identity/1) |> Enum.map(&parser.(&1))

    map = :array.fix(:array.from_list(items, nil))

    %GridMap{size: {w, h}, map: map}
  end

  def size(topo) do
    Map.get(topo, :size)
  end

  def at(topo, x, y) do
    at(topo, {x, y})
  end

  def at(%GridMap{map: map, size: {w, h}}, {x, y}) do
    cond do
      x < 0 -> nil
      y < 0 -> nil
      x >= w -> nil
      y >= h -> nil
      true -> :array.get(y * w + x, map)
    end
  end

  def set(map, {x, y}, v) do
    {w, h} = GridMap.size(map)
    arr = Map.get(map, :map)

    new_arr =
      cond do
        x < 0 -> arr
        y < 0 -> arr
        x >= w -> arr
        y >= h -> arr
        true -> :array.set(y * w + x, v, arr)
      end

    Map.put(map, :map, new_arr)
  end

  def find(map, pred) do
    {w, h} = size(map)

    for x <- 0..(w - 1), y <- 0..(h - 1), pred.(at(map, x, y)), do: {x, y}
  end

  def neighbors(map, x, y) do
    neighbors(map, {x, y})
  end

  def neighbors(map, p) do
    all_neighbors(map, p) |> Enum.filter(fn {_, v} -> v != nil end)
  end

  def all_neighbors(map, p) do
    dirs = [
      V.add(p, {1, 0}),
      V.add(p, {0, 1}),
      V.add(p, {-1, 0}),
      V.add(p, {0, -1})
    ]

    dirs |> Enum.map(&{&1, at(map, &1)})
  end

  def swap(map, a, b) do
    av = GridMap.at(map, a)
    bv = GridMap.at(map, b)

    map = GridMap.set(map, a, bv)

    GridMap.set(map, b, av)
  end

  def to_string(map) do
    {w, h} = GridMap.size(map)

    for y <- 0..(h - 1) do
      0..(w - 1) |> Enum.map(&GridMap.at(map, &1, y)) |> Enum.join()
    end
    |> Enum.join("\n")
  end

  def print(map) do
    IO.puts(GridMap.to_string(map))
  end
end
