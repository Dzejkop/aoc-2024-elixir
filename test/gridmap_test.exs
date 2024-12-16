defmodule GridmapTest do
  use ExUnit.Case, async: true

  test "basic" do
    m = """
      123
      456
      789
    """

    g = GridMap.parse(m)

    assert "1" == GridMap.at(g, 0, 0)
    assert "5" == GridMap.at(g, 1, 1)
    assert "9" == GridMap.at(g, 2, 2)
  end
end
