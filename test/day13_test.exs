defmodule Day13Test do
  use ExUnit.Case, async: true

  alias Day13.Section, as: Section

  test "parse section" do
    section = """
    Button A: X+94, Y+32
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400
    """

    {section, _content} = Section.parse(section)

    assert {94, 32} == Section.button_a(section)
    assert {22, 67} == Section.button_b(section)
    assert {8400, 5400} == Section.prize_loc(section)
  end

  test "parse many" do
    content = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

    items = Section.parse_multiple(content)

    assert 4 == length(items)
  end

  test "cheapest" do
    section = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400
    """

    {section, _content} = Section.parse(section)

    assert 280 == Day13.cheapest_prize(section)
  end
end
