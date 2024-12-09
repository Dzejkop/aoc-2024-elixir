reg = ~r/mul\((\d+),(\d+)\)/

[filename] = System.argv()

data = File.read!(filename)

muls = Regex.scan(reg, data)

sum = Enum.map(muls, fn [_expr, a, b] ->
  a = String.to_integer(a)
  b = String.to_integer(b)

  a * b
end) |> Enum.sum()

IO.puts("#{sum}")
