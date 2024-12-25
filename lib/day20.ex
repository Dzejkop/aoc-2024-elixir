defmodule Day20 do
  def part_one(content, cheat_limit \\ 100) do
    map = GridMap.parse(content)
    [start] = GridMap.find(map, &(&1 == "S"))
    [finish] = GridMap.find(map, &(&1 == "E"))
    xs = [start, finish]
    map = Enum.reduce(xs, map, fn x, map -> GridMap.set(map, x, ".") end)

    graph = Day20.map_to_graph(map)

    IO.puts("Bellman-Ford")
    ford = Graph.bellman_ford(graph, finish)

    all_walls = GridMap.find(map, &(&1 == "#"))
    cheat_candidates = Enum.flat_map(all_walls, &wall_to_cheats(map, &1))

    IO.puts("Evaluating cheats")

    good_cheats =
      cheat_candidates
      |> Enum.map(&eval_cheat(ford, &1))
      |> Enum.filter(&(&1 >= cheat_limit))
      |> Enum.count()

    good_cheats
  end

  def part_two(content, cheat_limit \\ 100) do
    map = GridMap.parse(content)
    [start] = GridMap.find(map, &(&1 == "S"))
    [finish] = GridMap.find(map, &(&1 == "E"))
    xs = [start, finish]
    map = Enum.reduce(xs, map, fn x, map -> GridMap.set(map, x, ".") end)

    graph = Day20.map_to_graph(map)
    wall_graph = Day20.map_to_wall_graph(map)

    IO.puts("Bellman-Ford")
    ford = Graph.bellman_ford(graph, finish)

    all_tiles = GridMap.find(map, &(&1 == "."))

    dbg(
      for a <- all_tiles,
          b <- all_tiles,
          a != b,
          cheat_val = eval_cheat(ford, {a, b}),
          cheat_val >= cheat_limit,
          do: {{a, b}, cheat_val}
    )

    cheats =
      for a <- all_tiles,
          b <- all_tiles,
          a != b,
          cheat_val = eval_cheat(ford, {a, b}),
          cheat_val >= cheat_limit,
          cheat_path = Graph.dijkstra(wall_graph, a, b),
          path_len = length(cheat_path),
          path_len <= 20 do
        {a, b}
      end

    cheats

    # all_walls = GridMap.find(map, &(&1 == "#"))
    # cheat_candidates = Enum.flat_map(all_walls, &wall_to_cheats(map, &1))

    # IO.puts("Evaluating cheats")

    # good_cheats =
    #   cheat_candidates
    #   |> Enum.map(&eval_cheat(ford, &1))
    #   |> Enum.filter(&(&1 >= cheat_limit))
    #   |> Enum.count()

    # good_cheats
  end

  def taxi_distance(a, b) do
    {x, y} = V.vabs(V.sub(a, b))
    x + y
  end

  def map_to_graph(map) do
    {w, h} = GridMap.size(map)

    ps = for x <- 0..(w - 1), y <- 0..(h - 1), do: {x, y}

    graph =
      ps
      |> Enum.filter(&(GridMap.at(map, &1) == "."))
      |> Enum.reduce(Graph.new(), fn p, g ->
        build_map_point_siblings(map, g, p, &(&1 == "."))
      end)

    graph
  end

  # Build a graph where we can traverse inside walls
  # And also enter/exit onto regular tiles
  def map_to_wall_graph(map) do
    {w, h} = GridMap.size(map)

    ps = for x <- 0..(w - 1), y <- 0..(h - 1), do: {x, y}

    graph =
      ps
      |> Enum.filter(&(GridMap.at(map, &1) == "#"))
      |> Enum.reduce(Graph.new(), fn p, g ->
        build_map_point_siblings(map, g, p, &(&1 == "." or &1 == "#"), true)
      end)

    graph
  end

  def build_map_point_siblings(
        map,
        graph,
        p,
        pred \\ fn t -> t == "." end,
        bidirectional \\ false
      ) do
    dirs = [
      {1, 0},
      {0, 1},
      {-1, 0},
      {0, -1}
    ]

    edge_positions =
      dirs
      |> Enum.map(&V.add(p, &1))
      |> Enum.filter(&pred.(GridMap.at(map, &1)))

    Enum.reduce(edge_positions, graph, fn np, g ->
      g = Graph.add_edge(g, p, np)

      if bidirectional do
        Graph.add_edge(g, np, p)
      else
        g
      end
    end)
  end

  def wall_to_cheats(map, wall_pos) do
    dirs = [
      {1, 0},
      {0, 1},
      {-1, 0},
      {0, -1}
    ]

    for s <- dirs,
        e <- dirs,
        s != e,
        s = V.add(wall_pos, s),
        e = V.add(wall_pos, e),
        GridMap.at(map, s) == "." and GridMap.at(map, e) == "." do
      {s, e}
    end
  end

  def eval_cheat(ford, {start, finish}) do
    cheat_val = Map.get(ford, finish) - Map.get(ford, start)

    # The cheat itself takes 2 steps
    cheat_val - 2
  end
end
