defmodule AOC do
  def start(_type, args) do
    IO.puts("Hello: #{inspect(args)}")

    data = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    lines =
      String.split(data, "\n")
      |> Enum.map(&String.trim(&1))
      |> reject_empty

    parsed =
      lines
      |> Enum.map(&(String.split(&1, " ") |> reject_empty))
      |> Enum.map(&dbg(&1))
      |> Enum.map(fn xs -> Enum.map(xs, &String.to_integer(&1)) end)

    IO.puts("#{inspect(parsed)}")

    {:ok, self()}
  end

  def reject_empty(xs) do
    Enum.reject(xs, fn s -> String.length(s) == 0 end)
  end
end
