defmodule Day18 do
  def part_one(f, {w, h}, n) do
    content = File.read!(f)
    bytes = parse(content) |> Enum.take(n)

    map = simulate(bytes, {w, h})
    graph = map_to_graph(map)

    path = Graph.dijkstra(graph, {0, 0}, {w - 1, h - 1})
    length(path)
  end

  def part_two(f, {w, h}, n) do
    content = File.read!(f)
    all_bytes = parse(content)
    bytes = Enum.take(all_bytes, n)
    rem_bytes = Enum.drop(all_bytes, n)

    sol_idx = attempt(bytes, rem_bytes, {w, h})

    Enum.at(rem_bytes, sol_idx - 1)
  end

  def attempt(start_bytes, bytes, {w, h}) do
    # 1 + because we're iterating over gaps between items
    s = 1 + length(bytes)
    half = trunc((1 + length(bytes)) / 2)

    do_while({s, half}, fn {s, curr} ->
      a = curr
      b = curr + 1

      a_bytes = start_bytes ++ Enum.take(bytes, a)
      b_bytes = start_bytes ++ Enum.take(bytes, b)

      a_sol = solve(a_bytes, {w, h}) != nil
      b_sol = solve(b_bytes, {w, h}) != nil

      next_s = trunc(s / 2)
      step = trunc(:math.ceil(s / 4))

      case {a_sol, b_sol} do
        _ when s == 0 -> {:break, nil}
        # the current spot is unsolvable
        # we need to consider the lower half
        {false, false} -> {:cont, {next_s, curr - step}}
        # Solution!
        {true, false} -> {:break, b}
        # Consider the upper half
        {true, true} -> {:cont, {next_s, curr + step}}
      end
    end)
  end

  def do_while(state, step) do
    {res, new_state} = step.(state)

    case res do
      :break -> new_state
      _ -> do_while(new_state, step)
    end
  end

  def solve(bytes, {w, h}) do
    map = simulate(bytes, {w, h})
    graph = map_to_graph(map)

    Graph.dijkstra(graph, {0, 0}, {w - 1, h - 1})
  end

  def parse(content) do
    lines =
      for line <- String.split(content, "\n"), line = String.trim(line), line != "", do: line

    coords =
      for line <- lines,
          [x, y] = String.split(line, ","),
          do: {String.to_integer(x), String.to_integer(y)}

    coords
  end

  def simulate(bytes, {w, h}) do
    map = GridMap.new(w, h, ".")

    Enum.reduce(bytes, map, fn pos, map ->
      GridMap.set(map, pos, "#")
    end)
  end

  def map_to_graph(map) do
    graph = Graph.new()

    coords = GridMap.find(map, &(&1 == "."))

    Enum.reduce(coords, graph, fn c, g ->
      neighbors = GridMap.neighbors(map, c)
      neighbors = for {nc, nv} <- neighbors, nv != "#", do: nc

      Enum.reduce(neighbors, g, fn nc, g ->
        Graph.add_edge(g, c, nc)
        Graph.add_edge(g, nc, c)
      end)
    end)
  end
end
