defmodule D4 do
  def at(mat, {x, y}) do
    cond do
      x < 0 ->
        nil

      y < 0 ->
        nil

      true ->
        row = Enum.at(mat, y)

        if row do
          Enum.at(row, x)
        else
          nil
        end
    end
  end

  def vadd({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def vmul({x, y}, m) do
    {x * m, y * m}
  end

  def dir(mat, {x, y}, dir) do
    [
      at(mat, vadd({x, y}, vmul(dir, 0))),
      at(mat, vadd({x, y}, vmul(dir, 1))),
      at(mat, vadd({x, y}, vmul(dir, 2))),
      at(mat, vadd({x, y}, vmul(dir, 3)))
    ]
  end

  def right(mat, {x, y}), do: dir(mat, {x, y}, {1, 0})
  def left(mat, {x, y}), do: dir(mat, {x, y}, {-1, 0})
  def up(mat, {x, y}), do: dir(mat, {x, y}, {0, -1})
  def down(mat, {x, y}), do: dir(mat, {x, y}, {0, 1})

  def right_down(mat, {x, y}), do: dir(mat, {x, y}, {1, 1})
  def left_down(mat, {x, y}), do: dir(mat, {x, y}, {-1, 1})
  def right_up(mat, {x, y}), do: dir(mat, {x, y}, {1, -1})
  def left_up(mat, {x, y}), do: dir(mat, {x, y}, {-1, -1})

  def all(mat, coord) do
    [
      right(mat, coord),
      left(mat, coord),
      up(mat, coord),
      down(mat, coord),
      right_down(mat, coord),
      left_down(mat, coord),
      right_up(mat, coord),
      left_up(mat, coord)
    ]
  end
end

[filename] = System.argv()

content = File.read!(filename)

lines = String.split(content, "\n")

mat = Enum.map(lines, &String.codepoints/1)

h = length(mat)
w = length(Enum.at(mat, 0))

coords = for y <- 0..(h - 1), x <- 0..(w - 1), do: {x, y}

total =
  for {x, y} <- coords do
    dirs = D4.all(mat, {x, y})

    Enum.filter(dirs, fn xs ->
      xs == ["X", "M", "A", "S"]
    end)
    |> Enum.count()
  end
  |> Enum.sum()

IO.puts("#{total}")
