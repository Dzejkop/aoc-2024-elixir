defmodule Day19Test do
  use ExUnit.Case, async: true

  test "parse available towles" do
    available = "r, wr, b, g, bwu, rb, gb, br"
    exp = ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]

    assert exp == Day19.parse_available_towels(available)
  end

  test "parse designs" do
    designs = """
    brwrr
    bggr
    gbbr
    """

    exp = ["brwrr", "bggr", "gbbr"]

    assert exp == Day19.parse_designs(designs)
  end

  test "is design possible" do
    towels = ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]
    assert Day19.possible?("brwrr", towels)
    assert Day19.possible?("bggr", towels)
    assert Day19.possible?("gbbr", towels)
    assert Day19.possible?("rrbgbr", towels)
    assert not Day19.possible?("ubwu", towels)
    assert Day19.possible?("bwurrg", towels)
    assert Day19.possible?("brgr", towels)
    assert not Day19.possible?("bbrgwb", towels)
  end
end
