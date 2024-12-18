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

  def eval_path(xs) do
    [:s, x | xs] = xs

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

  def eval_path(_, [:e | _]) do
    0
  end
end
