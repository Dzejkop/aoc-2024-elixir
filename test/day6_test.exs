defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "basic" do
    content = """
    #..
    ..#
    .^.
    """

    map = Day6.LabMap.parse(content)

    %Day6.LabMap{
      obstacles: obstacles,
      guard_dir: guard_dir,
      guard_pos: guard_pos
    } = map

    assert obstacles == [[true, false, false], [false, false, true], [false, false, false]]
    assert guard_pos == {1, 2}
    assert guard_dir == {0, -1}

    assert Day6.LabMap.obstacle(map, {0, 0}) == true
    assert Day6.LabMap.obstacle(map, {1, 0}) == false
    assert Day6.LabMap.obstacle(map, {2, 1}) == true

    assert Day6.LabMap.obstacle(map, {-1, -1}) == nil
    assert Day6.LabMap.obstacle(map, {7, 7}) == nil
    assert Day6.LabMap.obstacle(map, {1, 7}) == nil

    map = Day6.LabMap.step(map)

    assert Day6.LabMap.pos(map) == {1, 1}
  end
end
