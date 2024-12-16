defmodule Day12Test do
  use ExUnit.Case, async: true

  test "flood map" do
    map = """
      112
      112
      333
    """

    map = GridMap.parse(map)

    regions = [
      # region 2
      MapSet.new([{2, 0}, {2, 1}]),
      # region 3
      MapSet.new([{0, 2}, {1, 2}, {2, 2}]),
      # region 1
      MapSet.new([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
    ]

    assert regions == Day12.flood(map)
  end

  test "flood map single tile" do
    map = """
      112
      172
      333
    """

    map = GridMap.parse(map)

    regions = [
      # region 2
      MapSet.new([{2, 0}, {2, 1}]),
      # region 7
      MapSet.new([{1, 1}]),
      # region 3
      MapSet.new([{0, 2}, {1, 2}, {2, 2}]),
      # region 1
      MapSet.new([{0, 0}, {0, 1}, {1, 0}])
    ]

    assert regions == Day12.flood(map)
  end

  test "example" do
    map = """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
    """

    map = GridMap.parse(map)

    regions = Day12.flood(map)

    price = Day12.eval(map, regions)

    assert 1930 == price
  end
end

