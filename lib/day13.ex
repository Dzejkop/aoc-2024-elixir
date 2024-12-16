defmodule Day13 do
  defmodule Section do
    defstruct [:button_a, :button_b, :prize_loc]

    def parse_multiple(content) do
      if String.trim(content) == "" do
        []
      else
        {next, content} = parse(content)

        [next | parse_multiple(content)]
      end
    end

    def parse(content) do
      content = String.trim(content)

      "Button A: X+" <> content = content

      {button_a_x, content} = Integer.parse(content)
      ", Y+" <> content = content

      {button_a_y, content} = Integer.parse(content)

      "\nButton B: X+" <> content = content
      {button_b_x, content} = Integer.parse(content)
      ", Y+" <> content = content
      {button_b_y, content} = Integer.parse(content)

      "\nPrize: X=" <> content = content
      {prize_x, content} = Integer.parse(content)
      ", Y=" <> content = content
      {prize_y, content} = Integer.parse(content)

      s = %Section{
        button_a: {button_a_x, button_a_y},
        button_b: {button_b_x, button_b_y},
        prize_loc: {prize_x, prize_y}
      }

      {s, content}
    end

    def button_a(%Section{button_a: button_a}) do
      button_a
    end

    def button_b(%Section{button_b: button_b}) do
      button_b
    end

    def prize_loc(%Section{prize_loc: prize_loc}) do
      prize_loc
    end
  end

  def max_presses(), do: 100

  def eval_sections(sections) do
    streams = Task.async_stream(sections, fn section -> cheapest_prize(section) end)

    streams
    |> Stream.filter(fn {s, v} -> s == :ok and v != nil end)
    |> Stream.map(fn {:ok, v} -> v end)
    |> Enum.sum()
  end

  def cheapest_prize(section) do
    coords = for x <- 0..100, y <- 0..100, do: {x, y}

    coords |> Stream.map(&prize(section, &1)) |> Enum.min()
  end

  def prize(section, {a, b}) do
    ap = V.mul(Section.button_a(section), a)
    bp = V.mul(Section.button_b(section), b)

    if V.add(ap, bp) == Section.prize_loc(section) do
      a * 3 + b
    else
      nil
    end
  end
end
