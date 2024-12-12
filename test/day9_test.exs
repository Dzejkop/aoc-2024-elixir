defmodule Day9Test do
  use ExUnit.Case

  test "parse input" do
    assert [0, 0, nil, nil, nil, 1, 1, 1, nil, nil, nil] == Day9.parse_input("2333")
  end

  test "sort" do
    data = Day9.parse_input("12345")
    assert [0, 2, 2, 1, 1, 1, 2, 2, 2] == Day9.sort(data)
  end

  test "solve example" do
    data = Day9.parse_input("2333133121414131402")
    sorted = Day9.sort(data)
    checksum = Day9.checksum(sorted)

    assert 1928 = checksum
  end
end
