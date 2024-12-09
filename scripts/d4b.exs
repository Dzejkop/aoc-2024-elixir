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
      at(mat, vadd({x, y}, vmul(dir, 2)))
    ]
  end

  def right(mat, {x, y}), do: dir(mat, {x, y}, {1, 0})

  def xsq(mat, coord) do
    [
      right(mat, coord),
      right(mat, vadd(coord, {0, 1})),
      right(mat, vadd(coord, {0, 2}))
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
  Enum.map(coords, fn coord ->
    sq = D4.xsq(mat, coord)

    a =
      case sq do
        [["M", _, "S"], [_, "A", _], ["M", _, "S"]] -> 1
        _ -> 0
      end

    b =
      case sq do
        [["S", _, "S"], [_, "A", _], ["M", _, "M"]] -> 1
        _ -> 0
      end

    c =
      case sq do
        [["S", _, "M"], [_, "A", _], ["S", _, "M"]] -> 1
        _ -> 0
      end

    d =
      case sq do
        [["M", _, "M"], [_, "A", _], ["S", _, "S"]] -> 1
        _ -> 0
      end

    a + b + c + d
  end)
  |> Enum.sum()

IO.puts("#{total}")
