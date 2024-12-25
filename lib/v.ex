defmodule V do
  def add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def sub({ax, ay}, {bx, by}) do
    {ax - bx, ay - by}
  end

  def mul({x, y}, m) do
    {x * m, y * m}
  end

  def vrem({x, y}, {w, h}) do
    {rem(x, w), rem(y, h)}
  end

  def length({x, y}) do
    :math.sqrt(x * x + y * y)
  end

  def dist(a, b) do
    V.length(V.sub(a, b))
  end

  def vabs({x, y}) do
    {abs(x), abs(y)}
  end
end
