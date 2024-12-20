defmodule Day18 do
  def part_one(f, {w, h}, n) do
    content = File.read!(f)
    bytes = parse(content) |> Enum.take(n)

    map = simulate(bytes, {w, h})
    dbg(map)
    graph = map_to_graph(map)
    dbg(graph)

    path = Graph.dijkstra(graph, {0, 0}, {w - 1, h - 1})
    dbg(path)
    length(path)
  end

  def parse(content) do
    lines =
      for line <- String.split(content, "\n"), line = String.trim(line), line != "", do: line

    coords =
      for line <- lines,
          [x, y] = String.split(line, ","),
          do: {String.to_integer(x), String.to_integer(y)}

    coords
  end

  def simulate(bytes, {w, h}) do
    map = GridMap.new(w, h, ".")

    Enum.reduce(bytes, map, fn pos, map ->
      GridMap.set(map, pos, "#")
    end)
  end

  def map_to_graph(map) do
    graph = Graph.new()

    coords = GridMap.find(map, &(&1 == "."))

    Enum.reduce(coords, graph, fn c, g ->
      neighbors = GridMap.neighbors(map, c)
      neighbors = for {nc, nv} <- neighbors, nv != "#", do: nc

      Enum.reduce(neighbors, g, fn nc, g ->
        Graph.add_edge(g, c, nc)
        Graph.add_edge(g, nc, c)
      end)
    end)
  end
end
