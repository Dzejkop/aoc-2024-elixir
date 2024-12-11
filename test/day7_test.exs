defmodule Day7Test do
  use ExUnit.Case

  test "parse line" do
    assert {190, [10, 19]} == Day7.parse_line("190: 10 19")
    assert {21037, [9, 7, 18, 13]} ==
             Day7.parse_line("21037: 9 7 18 13")
  end

  test "parse content" do
    assert [{190, [10, 19]}] == Day7.parse_input("190: 10 19")
    assert [{190, [10, 19]}, {21037, [9, 7, 18, 13]}] ==
             Day7.parse_input("190: 10 19\n21037: 9 7 18 13")
  end

  test "solve example" do
    content = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    data = Day7.parse_input(content)

    assert 3749 == Day7.solve(data)
  end

  test "sums" do
    assert [3, 2] == Day7.all_sums([1, 2])
    assert [22, 121] == Day7.all_sums([11, 11])
    assert [6, 9, 5, 6] == Day7.all_sums([1, 2, 3])
  end
end
