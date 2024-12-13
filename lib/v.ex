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
end
