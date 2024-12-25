defmodule Day20Test do
  use ExUnit.Case, async: true

  test "example" do
    content = """
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """

    num_cheats = Day20.part_one(content, 1)

    assert 44 == num_cheats
  end

  test "example part two" do
    content = """
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """

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

    path = Graph.dijkstra(graph, finish, start)

    pairs = path_pairs(path)

    dbg(pairs)
    dbg(length(pairs))

    # Filter out by potential gaoin
    # We want potential gain differences of at least (50 - 20 = 30)
    xs =
      for {a, b} <- pairs,
          av = Map.get(ford, a),
          bv = Map.get(ford, b),
          gain = bv- av,
          gain >= 50 do
        # Invert the pair
        {{a, b}, gain}
      end

    paths =
      for {{a, b}, gain} <- xs,
          path = Graph.dijkstra(wall_graph, b, a),
          path_len = length(path),
          path_len <= 20,
          actual_gain = gain - path_len,
          actual_gain + 1 == 70 do
        {path, gain, actual_gain}
      end

    dbg(paths)
    dbg(length(paths))

    # dbg(Enum.any?(xs, &(&1 == {{1, 3}, {3, 3}})))
    # dbg(Enum.any?(xs, &(&1 == {{3, 3}, {1, 3}})))

    # num_cheats = Day20.part_two(content, 50)

    # assert 285 == num_cheats
  end

  test "path pairs" do
    assert [{1, 2}, {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}] == path_pairs([1, 2, 3, 4])
  end

  def path_pairs([x | xs]) do
    Enum.concat(
      path_pairs(x, xs),
      path_pairs(xs)
    )
  end

  def path_pairs([]) do
    []
  end

  def path_pairs(q, [x | xs]) do
    [{q, x} | path_pairs(q, xs)]
  end

  def path_pairs(_q, []) do
    []
  end
end
