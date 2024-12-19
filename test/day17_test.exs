defmodule Day17Test do
  use ExUnit.Case, async: true

  test "program parse" do
    program = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

    {ra, rb, rc, program} = Day17.parse(program)

    assert 729 == ra
    assert 0 == rc
    assert 0 == rb

    assert [0, 1, 5, 4, 3, 0] == program
  end

  test "samples" do
    rs = {0, 0, 9}

    {rs, _, _} = Day17.exec(rs, 0, [], 2, 6)

    assert {0, 1, 9} == rs
  end

  test "sample 2" do
    assert [0, 1, 2] == Day17.exec_program([5, 0, 5, 1, 5, 4], {10, 0, 0})
  end

  test "sample 3" do
    assert [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0] ==
             Day17.exec_program([0, 1, 5, 4, 3, 0], {2024, 0, 0})
  end

  test "program exec" do
    program = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

    {ra, rb, rc, program} = Day17.parse(program)

    out = Day17.exec_program(program, {ra, rb, rc})

    assert [4, 6, 3, 5, 6, 3, 5, 2, 1, 0] == out
  end
end
