defmodule Day10 do
  defmodule Topo do
    defstruct size: {0, 0}, map: nil

    def parse(s) do
      rows =
        String.split(s, "\n")
        |> Enum.map(&String.trim/1)
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&String.codepoints/1)

      h = length(rows)
      w = length(Enum.at(rows, 0))

      items = rows |> Enum.flat_map(& &1) |> Enum.map(&String.to_integer/1)

      map = :array.fix(:array.from_list(items, nil))

      %Topo{size: {w, h}, map: map}
    end

    def size(topo) do
      Map.get(topo, :size)
    end

    def at(topo, x, y) do
      at(topo, {x, y})
    end

    def at(%Topo{map: map, size: {w, h}}, {x, y}) do
      cond do
        x < 0 -> nil
        y < 0 -> nil
        x >= w -> nil
        y >= h -> nil
        true -> :array.get(y * w + x, map)
      end
    end

    def find(map, pred) do
      {w, h} = size(map)

      for x <- 0..(w - 1), y <- 0..(h - 1), pred.(at(map, x, y)), do: {x, y}
    end

    def neighbors(map, x, y) do
      neighbors(map, {x, y})
    end

    def neighbors(map, p) do
      dirs = [
        V.add(p, {1, 0}),
        V.add(p, {0, 1}),
        V.add(p, {-1, 0}),
        V.add(p, {0, -1})
      ]

      dirs |> Stream.map(&{&1, at(map, &1)}) |> Enum.filter(fn {_, v} -> v != nil end)
    end
  end

  def part_one(f) do
    map = File.read!(f)
    map = Topo.parse(map)

    solve(map)
  end

  def solve(map) do
    trailheads = Topo.find(map, &(&1 == 0))

    trailheads
    |> Enum.map(fn t ->
      reachable = reachable_trailends(map, t)
      score = length(reachable)

      score
    end)
    |> Enum.sum()
  end

  def reachable_trailends(map, p) do
    r = reachable_trailends(map, p, MapSet.new())
    # unique
    MapSet.to_list(MapSet.new(r))
  end

  def reachable_trailends(map, p, visited) do
    v = Topo.at(map, p)

    if v == 9 do
      [p]
    else
      neighbors = Topo.neighbors(map, p) |> Enum.reject(&MapSet.member?(visited, &1))

      if neighbors == [] do
        []
      else
        visited = MapSet.put(visited, p)
        xs = for {np, nv} <- neighbors, nv - v == 1, do: reachable_trailends(map, np, visited)

        Enum.flat_map(xs, & &1)
      end
    end
  end
end
