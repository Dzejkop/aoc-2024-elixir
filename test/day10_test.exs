defmodule Day10Test do
  use ExUnit.Case, async: true

  alias Day10.Topo, as: Topo

  test "parse map" do
    map = """
    0123
    1234
    8765
    9876
    """

    map = Topo.parse(map)

    assert {4, 4} = Topo.size(map)

    assert 0 == Topo.at(map, 0, 0)
    assert 7 == Topo.at(map, 1, 2)
    assert 6 == Topo.at(map, 3, 3)
  end

  test "find trailhead starts" do
    map = """
    0123
    1234
    8760
    9076
    """

    map = Topo.parse(map)

    assert [{0, 0}, {1, 3}, {3, 2}] == Topo.find(map, &(&1 == 0))
  end

  test "neighbors" do
    map = """
    0123
    1234
    8760
    9076
    """

    map = Topo.parse(map)

    assert [
             {{2, 1}, 3},
             {{1, 2}, 7},
             {{0, 1}, 1},
             {{1, 0}, 1}
           ] == Topo.neighbors(map, {1, 1})

    assert [
             {{1, 0}, 1},
             {{0, 1}, 1}
           ] == Topo.neighbors(map, {0, 0})

    assert [
             {{2, 3}, 7},
             {{3, 2}, 0}
           ] == Topo.neighbors(map, {3, 3})
  end

  test "reachable trailends" do
    map = """
    0123
    1234
    8765
    9876
    """

    map = Topo.parse(map)
    trailhead = {0, 0}

    assert [{0, 3}] == Day10.reachable_trailends(map, trailhead)
  end

  test "reachable trailends bigger" do
    map = """
    5550555
    5551555
    5552555
    6543456
    7555557
    8555558
    9555559
    """

    map = Topo.parse(map)
    trailhead = {3, 0}

    assert [{0, 6}, {6, 6}] == Day10.reachable_trailends(map, trailhead)
  end

  test "solve example" do
    map = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    map = Topo.parse(map)
    assert 36 == Day10.solve(map)
  end
end
