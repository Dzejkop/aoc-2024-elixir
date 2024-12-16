defmodule Day12 do
  def parse(content) do
    GridMap.parse(content)
  end

  def flood(map) do
    {w, h} = GridMap.size(map)
    coords = for x <- 0..(w - 1), y <- 0..(h - 1), do: {x, y}

    state = {
      # All visited
      MapSet.new(),

      # regions
      []
    }

    {_all_visited, regions} =
      coords
      |> Enum.reduce(state, fn coord, state ->
        visit_tile(map, coord, state)
      end)

    regions
  end

  # Evaluates the regions with area and perimiter each
  def eval(map, regions) do
    regions |> Enum.map(&eval_region(map, &1)) |> Enum.sum()
  end

  def eval_region(map, region) do
    region_char = GridMap.at(map, Enum.at(region, 0))

    area = MapSet.size(region)

    perimiter =
      region
      |> Enum.map(fn r ->
        GridMap.all_neighbors(map, r)
        |> Stream.filter(fn {_p, neighbor} -> neighbor != region_char end)
        |> Enum.count()
      end)
      |> Enum.sum()

    area * perimiter
  end

  def visit_tile(map, p, {all_visited, regions}) do
    if MapSet.member?(all_visited, p) do
      {all_visited, regions}
    else
      new_region =
        fill_region(map, p, MapSet.new([p]))

      regions = [new_region | regions]

      all_visited = MapSet.union(all_visited, new_region)

      {all_visited, regions}
    end
  end

  def fill_region(map, p, region) do
    v = GridMap.at(map, p)

    candidates =
      for {neighbor_pos, neighbor} <- GridMap.neighbors(map, p),
          neighbor == v and not MapSet.member?(region, neighbor_pos),
          do: neighbor_pos

    region = candidates |> Enum.reduce(region, &MapSet.put(&2, &1))

    region =
      candidates
      |> Enum.reduce(region, fn candidate, region ->
        fill_region(map, candidate, region)
      end)

    region
  end
end
