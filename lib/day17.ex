defmodule Day17 do
  def part_one(f) do
    content = File.read!(f)
    {ra, rb, rc, program} = parse(content)
    out = exec_program(program, {ra, rb, rc})

    Enum.join(out, "")
  end

  def parse(s) do
    [ra, rb, rc, p] = for s <- String.split(s, "\n"), s = String.trim(s), s != "", do: s

    ra = parse_register_init(ra)
    rb = parse_register_init(rb)
    rc = parse_register_init(rc)

    program = parse_program(p)

    {ra, rb, rc, program}
  end

  def parse_register_init(s) do
    "Register " <> rest = s
    s = String.slice(rest, 3..-1//1)

    String.to_integer(s)
  end

  def parse_program(s) do
    "Program: " <> p = s

    String.split(p, ",") |> Enum.map(&String.to_integer/1)
  end

  def exec_program(program, registers) do
    out = exec_program_loop(program, registers, 0, [])

    Enum.reverse(out)
  end

  def exec_program_loop(program, rs, c, out) do
    case Enum.at(program, c) do
      nil ->
        out

      p ->
        o = Enum.at(program, c + 1)
        {rs, c, out} = exec(rs, c, out, p, o)
        exec_program_loop(program, rs, c, out)
    end
  end

  # 0 - adv
  def exec({ra, rb, rc}, c, out, 0, o) do
    o = combo_value({ra, rb, rc}, o)

    num = ra
    den = :math.pow(2, o)

    res = num / den
    ra = trunc(res)

    {{ra, rb, rc}, c + 2, out}
  end

  # 1 - bxl
  def exec({ra, rb, rc}, c, out, 1, o) do
    rb = Bitwise.bxor(rb, o)

    {{ra, rb, rc}, c + 2, out}
  end

  # 2 - bst
  def exec({ra, rb, rc}, c, out, 2, o) do
    o = combo_value({ra, rb, rc}, o)
    rb = Bitwise.band(o, 7)

    {{ra, rb, rc}, c + 2, out}
  end

  # 3 - jnz
  def exec({ra, rb, rc}, c, out, 3, o) do
    if ra == 0 do
      {{ra, rb, rc}, c + 2, out}
    else
      {{ra, rb, rc}, o, out}
    end
  end

  # 4 - bxc
  def exec({ra, rb, rc}, c, out, 4, _o) do
    rb = Bitwise.bxor(rb, rc)

    {{ra, rb, rc}, c + 2, out}
  end

  # 5 - out
  def exec({ra, rb, rc}, c, out, 5, o) do
    o = Bitwise.band(combo_value({ra, rb, rc}, o), 7)

    out = [o | out]

    {{ra, rb, rc}, c + 2, out}
  end

  # 6 - bdv
  def exec({ra, rb, rc}, c, out, 6, o) do
    o = combo_value({ra, rb, rc}, o)

    num = ra
    den = :math.pow(2, o)

    res = num / den
    rb = trunc(res)

    {{ra, rb, rc}, c + 2, out}
  end

  # 7 - cdv
  def exec({ra, rb, rc}, c, out, 7, o) do
    o = combo_value({ra, rb, rc}, o)

    num = ra
    den = :math.pow(2, o)

    res = num / den
    rc = trunc(res)

    {{ra, rb, rc}, c + 2, out}
  end

  def combo_value({ra, rb, rc}, o) do
    case o do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> ra
      5 -> rb
      6 -> rc
      7 -> nil
    end
  end
end
