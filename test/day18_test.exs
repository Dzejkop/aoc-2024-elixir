defmodule Day18Test do
  use ExUnit.Case, async: true

  test "new map" do
    empty_map = GridMap.new(2, 2, ".")

    s = GridMap.to_string(empty_map)

    exp = """
    ..
    ..
    """

    exp = String.trim(exp)

    assert exp == s
  end

  test "parse input" do
    content = """
    5,4
    4,2
    4,5
    3,0
    """

    assert [{5, 4}, {4, 2}, {4, 5}, {3, 0}] == Day18.parse(content)
  end

  test "sim" do
    bytes = [{1, 1}, {0, 2}]
    map = Day18.simulate(bytes, {3, 3})
    act = GridMap.to_string(map)

    exp =
      String.trim("""
      ...
      .#.
      #..
      """)

    assert exp == act
  end

  test "map to graph" do
    content = """
    ...
    ##.
    .#.
    """

    map = GridMap.parse(content)
    graph = Day18.map_to_graph(map)

    path = Graph.dijkstra(graph, {0, 0}, {2, 2})
    assert [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}] == path
  end

  test "example" do
    content = """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

    bytes = Day18.parse(content) |> Enum.take(12)
    map = Day18.simulate(bytes, {7, 7})

    IO.puts("")
    GridMap.print(map)

    graph = Day18.map_to_graph(map)

    path = Graph.dijkstra(graph, {0, 0}, {6, 6})

    assert 22 == length(path) - 1
  end

  test "example - part two" do
    content = """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

    bytes = Day18.parse(content) |> Enum.take(12)
    map = Day18.simulate(bytes, {7, 7})

    IO.puts("")
    GridMap.print(map)

    graph = Day18.map_to_graph(map)

    path = Graph.dijkstra(graph, {0, 0}, {6, 6})

    assert 22 == length(path) - 1
  end
end
