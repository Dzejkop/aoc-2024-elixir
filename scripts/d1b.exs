filename = Enum.at(System.argv(), 0)
content = File.read!(filename)

lines =
  String.split(content, "\n")
  |> Enum.map(&String.trim(&1))
  |> AOC.reject_empty()

parsed =
  lines
  |> Enum.map(&(String.split(&1, " ") |> AOC.reject_empty()))
  |> Enum.map(fn xs -> Enum.map(xs, &String.to_integer(&1)) end)

parsed = for [a, b] <- parsed, do: {a, b}

{left, right} = Enum.unzip(parsed)

sum =
  for a <- left do
    a * (Enum.filter(right, &(&1 == a)) |> Enum.count())
  end
  |> Enum.sum()

IO.puts("#{sum}")
