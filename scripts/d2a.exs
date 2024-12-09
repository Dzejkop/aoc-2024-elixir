defmodule Report do
  def safe?(report) do
    windows = Report.windows(report)

    {fa, fb} = Enum.at(windows, 0)
    increasing? = fb > fa

    Enum.all?(windows, fn {a, b} ->
      monotony =
        if increasing? do
          b > a
        else
          a > b
        end

      diff = abs(a - b)
      safety = diff >= 1 and diff <= 3

      monotony and safety
    end)
  end

  def windows(xs) do
    [_ | shifted] = xs

    Enum.zip(xs, shifted)
  end
end

filename = Enum.at(System.argv(), 0)
content = File.read!(filename)

lines =
  String.split(content, "\n")
  |> Enum.map(&String.trim/1)
  |> Enum.reject(&(&1 == ""))

reports =
  for line <- lines do
    vs = String.split(line, " ")
    vs |> Enum.map(&String.to_integer(&1))
  end

num_safe_reports = Enum.filter(reports, &Report.safe?/1) |> Enum.count()

IO.puts(num_safe_reports)
