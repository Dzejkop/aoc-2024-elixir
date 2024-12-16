defmodule Day14Test do
  use ExUnit.Case, async: true

  test "parse input line" do
    assert {{0, 4}, {3, -3}} == Day14.parse_line("p=0,4 v=3,-3")
  end

  test "parse input" do
    content = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    """

    assert [{{0, 4}, {3, -3}}, {{6, 3}, {-1, -3}}] == Day14.parse(content)
  end

  test "predict" do
    assert {1, 3} == Day14.predict({2, 4}, {2, -3}, 5, {11, 7})
  end

  test "example" do
    content = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

    robots = Day14.parse(content)
    safety = Day14.eval_safety(robots, 100, {11, 7})

    assert 12 == safety
  end
end
