defmodule Day6 do
  defmodule LabMap do
    defstruct obstacles: [], guard_pos: {0, 0}, guard_dir: :up, size: {0, 0}

    def w(%LabMap{size: {w, _}}) do
      w
    end

    def h(%LabMap{size: {_, h}}) do
      h
    end

    def dir(%LabMap{guard_dir: dir}) do
      dir
    end

    def pos(%LabMap{guard_pos: pos}) do
      pos
    end

    def obstacle(%LabMap{obstacles: obstacles, size: {w, h}}, {x, y}) do
      cond do
        x < 0 -> nil
        y < 0 -> nil
        x >= w -> nil
        y >= h -> nil
        true -> Enum.at(obstacles, y) |> Enum.at(x)
      end
    end

    def step(map) do
      next_pos = vadd(pos(map), dir(map))

      if obstacle(map, next_pos) do
        %LabMap{map | guard_dir: vturn(LabMap.dir(map))}
      else
        %LabMap{map | guard_pos: next_pos}
      end
    end

    def vadd({ax, ay}, {bx, by}) do
      {ax + bx, ay + by}
    end

    def vturn({x, y}) do
      {-y, x}
    end

    def parse(content) do
      map_tiles =
        String.split(content, "\n")
        |> Stream.filter(&(&1 != ""))
        |> Enum.map(&String.codepoints(&1))

      h = length(map_tiles)
      w = length(Enum.at(map_tiles, 0))

      init_state = %{obstacles: [], guard_pos: {0, 0}, guard_dir: :up}

      %{obstacles: obstacles, guard_pos: guard_pos, guard_dir: guard_dir} =
        map_tiles
        |> Stream.map(&Enum.with_index(&1))
        |> Stream.with_index()
        |> Enum.reduce(init_state, fn {row, y}, acc ->
          Enum.reduce(row, acc, fn {tile, x}, acc ->
            parse_tile(acc, {x, y}, tile)
          end)
        end)

      obstacles = reconstruct_obstacles(w, h, obstacles)

      %LabMap{obstacles: obstacles, guard_pos: guard_pos, guard_dir: guard_dir, size: {w, h}}
    end

    def parse_tile(acc, {x, y}, tile) when tile in ["^", "v", ">", "<"] do
      %{
        acc
        | guard_dir: parse_dir(tile),
          guard_pos: {x, y}
      }
    end

    def parse_tile(acc, {x, y}, "#") do
      %{
        acc
        | obstacles: [{x, y} | Map.get(acc, :obstacles)]
      }
    end

    def parse_tile(acc, _, _) do
      acc
    end

    def parse_dir(dir) do
      case dir do
        "^" -> {0, -1}
        "v" -> {0, 1}
        ">" -> {1, 0}
        "<" -> {-1, 0}
      end
    end

    def reconstruct_obstacles(w, h, obstacle_list) do
      map =
        for _ <- 1..h do
          for _ <- 1..w, do: false
        end

      Enum.reduce(obstacle_list, map, fn {x, y}, map ->
        row = Enum.at(map, y)
        List.replace_at(map, y, List.replace_at(row, x, true))
      end)
    end
  end

  def part_one(f) do
    content = File.read!(f)
    map = LabMap.parse(content)

    visited = simulate(map, MapSet.new())

    num_visited = MapSet.size(visited)

    IO.puts("#{num_visited}")
  end

  def simulate(map, visited_set) do
    pos = LabMap.pos(map)

    if LabMap.obstacle(map, pos) == nil do
      visited_set
    else
      visited_set = MapSet.put(visited_set, pos)
      map = LabMap.step(map)
      simulate(map, visited_set)
    end
  end
end
