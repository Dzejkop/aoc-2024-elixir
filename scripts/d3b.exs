reg = ~r/mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)/

[filename] = System.argv()

data = File.read!(filename)

exprs = Regex.scan(reg, data)

{sum, _} = Enum.reduce(exprs, {0, true}, fn matches, {acc, enabled} ->
  case matches do
    ["do()"] -> {acc, true}
    ["don't()"] -> {acc, false}
    ["mul" <> _, a, b] when enabled ->
      a = String.to_integer(a)
      b = String.to_integer(b)

      {acc + a * b, enabled}
    _ -> {acc, enabled}
  end
end)

IO.puts("#{sum}")
