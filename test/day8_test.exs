defmodule Day8Test do
  use ExUnit.Case

  test "correct size" do
    assert {{5, 3}, %{}} ==
             Day8.parse_input("""
               .....
               .....
               .....
             """)
  end

  test "parse empty input" do
    assert {{3, 3}, %{}} ==
             Day8.parse_input("""
               ...
               ...
               ...
             """)
  end

  test "parse input - single item" do
    assert {{3, 3}, %{"a" => [{1, 1}]}} ==
             Day8.parse_input("""
               ...
               .a.
               ...
             """)
  end

  test "parse input - many items" do
    assert {{3, 3}, %{"a" => [{1, 1}], "#" => [{2, 1}, {0, 0}], "q" => [{2, 2}]}} ==
             Day8.parse_input("""
               #..
               .a#
               ..q
             """)
  end

  test "pairs" do
    assert [{{2, 1}, {0, 0}}, {{2, 1}, {1, 1}}, {{0, 0}, {1, 1}}] ==
             Day8.all_pairs([{2, 1}, {0, 0}, {1, 1}])
  end

  test "pair antinodes" do
    assert [{2, 0}] == Day8.pair_antinodes({3, 3}, {{0, 0}, {1, 0}})
    assert [{0, 0}, {3, 3}] == Day8.pair_antinodes({4, 4}, {{1, 1}, {2, 2}})
  end

  test "solve example" do
    content = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

    data = Day8.parse_input(content)

    assert 14 == Day8.solve(data)
  end
end
