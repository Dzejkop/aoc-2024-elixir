defmodule Day15 do
  def parse_move(move) do
    case move do
      "<" -> {-1, 0}
      "^" -> {0, -1}
      ">" -> {1, 0}
      "v" -> {0, 1}
    end
  end

  def parse_moves(moves) do
    moves |> String.codepoints() |> Enum.filter(&(&1 != "\n")) |> Enum.map(&parse_move/1)
  end

  def simulate(map, moves) do
    Enum.reduce(moves, map, &exec_move(&2, &1))
  end

  def score(map) do
    GridMap.find(map, &(&1 == "O")) |> Enum.map(fn {x, y} -> 100 * y + x end) |> Enum.sum()
  end

  def exec_move(map, move) do
    [robot_pos] = GridMap.find(map, &(&1 == "@"))

    {_, map} = attempt_move(map, robot_pos, move)

    map
  end

  def attempt_move(map, pos, move) do
    new_pos = V.add(pos, move)

    if GridMap.at(map, new_pos) == "#" do
      {:nomove, map}
    else
      if GridMap.at(map, new_pos) == "." do
        {:moved, GridMap.swap(map, pos, new_pos)}
      else
        {res, map} = attempt_move(map, new_pos, move)

        if res == :moved do
          {:moved, GridMap.swap(map, pos, new_pos)}
        else
          {:nomove, map}
        end
      end
    end
  end
end
