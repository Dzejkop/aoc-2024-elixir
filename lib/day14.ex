defmodule Day14 do
  def parse_line(line) do
    "p=" <> line = line
    {px, line} = Integer.parse(line)
    "," <> line = line
    {py, line} = Integer.parse(line)

    " v=" <> line = line
    {vx, line} = Integer.parse(line)
    "," <> line = line
    {vy, ""} = Integer.parse(line)

    {{px, py}, {vx, vy}}
  end

  def parse(content) do
    String.split(content, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse_line/1)
  end

  def predict(p, v, n, bounds) do
    {x, y} = V.vrem(V.add(p, V.mul(v, n)), bounds)
    {bx, by} = bounds

    x = if x < 0, do: bx + x, else: x
    y = if y < 0, do: by + y, else: y

    {x, y}
  end

  def eval_safety(robots, n \\ 100, bounds \\ {101, 103}) do
    future_positions = for {p, v} <- robots, do: predict(p, v, n, bounds)

    future_positions
    |> Enum.filter(&quadrant(&1, bounds))
    |> Enum.group_by(&quadrant(&1, bounds))
    |> Enum.map(fn {_, items} -> length(items) end)
    |> Enum.product()
  end

  def quadrant({x, y}, {bx, by}) do
    hbx = trunc(bx / 2)
    hby = trunc(by / 2)

    cond do
      x < hbx and y < hby -> 1
      x < hbx and y > hby -> 2
      x > hbx and y < hby -> 3
      x > hbx and y > hby -> 4
      true -> nil
    end
  end
end
