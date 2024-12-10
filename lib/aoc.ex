defmodule AOC do
  def reject_empty(xs) do
    Enum.reject(xs, fn s -> String.length(s) == 0 end)
  end
end
