defmodule Day11 do
  def parse(input) do
    String.split(input, " ") |> Enum.map(&String.to_integer/1)
  end

  def step([0 | xs]) do
    [1 | step(xs)]
  end

  def step([n | xs]) do
    if even_digits?(n) do
      [l, r] = split_digits(n)
      [l, r | step(xs)]
    else
      [n * 2024 | step(xs)]
    end
  end

  def step([]) do
    []
  end

  def num_digits(n) do
    trunc(:math.floor(:math.log10(n) + 1))
  end

  def even_digits?(1) do
    false
  end

  def even_digits?(n) do
    nd = num_digits(n)
    rem(nd, 2) == 0
  end

  def split_digits(n) do
    nd = num_digits(n)
    ns = Integer.to_string(n)

    {l, r} = String.split_at(ns, trunc(nd / 2))

    [String.to_integer(l), String.to_integer(r)]
  end

  def how_many_stones_after(stones, 0) do
    length(stones)
  end

  def how_many_stones_after(stones, num_blinks) do
    how_many_stones_after(step(stones), num_blinks - 1)
  end
end
