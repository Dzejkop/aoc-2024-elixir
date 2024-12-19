defmodule Day16 do
  def map_to_graph(map) do
    dirs = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
    [right, down, left, up] = dirs

    # Get all corridor positions
    corridors = GridMap.find(map, &(&1 == "." or &1 == "S" or &1 == "E"))

    # Graph
    graph = Graph.new()

    # Find start pos
    [s] = GridMap.find(map, &(&1 == "S"))
    # Add a special starting node
    graph = Graph.add_edge(graph, :s, {s, right})

    # Find end position
    [e] = GridMap.find(map, &(&1 == "E"))

    # Add end node connections
    graph =
      Enum.reduce(dirs, graph, fn d, g ->
        Graph.add_edge(g, {e, d}, :e)
      end)

    # Add vertices & edges
    graph =
      Enum.reduce(corridors, graph, fn c, g ->
        g = Graph.add_vertices(g, Enum.map(dirs, &{c, &1}))

        g = Graph.add_edge(g, {c, right}, {c, down}, weight: 1000)
        g = Graph.add_edge(g, {c, down}, {c, left}, weight: 1000)
        g = Graph.add_edge(g, {c, left}, {c, up}, weight: 1000)
        g = Graph.add_edge(g, {c, up}, {c, right}, weight: 1000)

        g = Graph.add_edge(g, {c, right}, {c, up}, weight: 1000)
        g = Graph.add_edge(g, {c, up}, {c, left}, weight: 1000)
        g = Graph.add_edge(g, {c, left}, {c, down}, weight: 1000)
        g = Graph.add_edge(g, {c, down}, {c, right}, weight: 1000)

        edges =
          for dir <- dirs,
              GridMap.at(map, V.add(c, dir)) in [".", "S", "E"] do
            t = {V.add(c, dir), dir}
            s = {c, dir}
            {s, t}
          end

        Graph.add_edges(g, edges)
      end)

    graph
  end

  def part_one(f) do
    content = File.read!(f)
    map = GridMap.parse(content)
    graph = map_to_graph(map)

    best_path = Graph.dijkstra(graph, :s, :e)

    eval_path(best_path)
  end

  def part_two(f) do
    content = File.read!(f)
    map = GridMap.parse(content)
    graph = map_to_graph(map)

    best = Graph.dijkstra(graph, :s, :e)
    best = eval_path(best)

    positions = GridMap.find(map, fn v -> v in [".", "S", "E"] end)
    [s] = GridMap.find(map, &(&1 == "S"))

    positions = Enum.sort_by(positions, &V.dist(&1, s))

    resting_spots = MapSet.new()

    resting_spots =
      Enum.reduce(positions, resting_spots, fn pos, spots ->
        IO.puts("Evaluating pos #{inspect(pos)}")

        if MapSet.member?(spots, pos) do
          IO.puts("Already a member")
          spots
        else
          IO.puts("Not a member - calculating")
          best_paths = best_paths_at_pos(graph, best, pos)

          unique_positions =
            best_paths
            |> Enum.flat_map(& &1)
            |> Enum.reject(&(&1 == :s or &1 == :e))
            |> Enum.map(fn {pos, _dir} -> pos end)
            |> Enum.into(MapSet.new())

          dbg(spots)

          IO.puts(
            "Adding #{MapSet.size(unique_positions)} entries (already have #{MapSet.size(spots)})"
          )

          MapSet.union(spots, unique_positions)
        end
      end)

    MapSet.size(resting_spots)
  end

  def best_paths_at_pos(graph, best, pos) do
    dirs = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

    best_paths =
      for dir <- dirs,
          first_half = Graph.dijkstra(graph, :s, {pos, dir}),
          second_half = Graph.dijkstra(graph, {pos, dir}, :e),
          cost = eval_path(first_half) + eval_path(second_half),
          cost == best,
          do: first_half ++ second_half

    best_paths
  end

  def eval_path([:s, x | xs]) do
    eval_path(x, xs)
  end

  def eval_path([x | xs]) do
    eval_path(x, xs)
  end

  def eval_path({xp, xd}, [{yp, yd} | ys]) do
    traverse_cost =
      if xp == yp do
        0
      else
        1
      end

    rotate_cost =
      if xd == yd do
        0
      else
        1000
      end

    cost = traverse_cost + rotate_cost

    cost + eval_path({yp, yd}, ys)
  end

  def eval_path(_, []) do
    0
  end

  def eval_path(_, [:e | _]) do
    0
  end
end
