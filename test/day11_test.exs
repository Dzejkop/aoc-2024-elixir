defmodule Day11Test do
  use ExUnit.Case, async: true

  import Day11

  test "parse input" do
    input = "0 1 125 67"

    assert [0, 1, 125, 67] == parse(input)
  end

  test "even digits" do
    assert not even_digits?(2)
    assert not even_digits?(4)
    assert not even_digits?(1)

    assert even_digits?(32)
    assert even_digits?(17)
    assert even_digits?(345_879)
  end

  test "step" do
    assert [253_000, 1, 7] == step([125, 17])
  end

  test "how many stones" do
    assert 22 == how_many_stones_after([125, 17], 6)
    assert 55312 == how_many_stones_after([125, 17], 25)
  end

  test "sanity check" do
    dbg(step([8069, 87014, 98, 809_367, 525, 0, 9_494_914, 5]))
  end
end
