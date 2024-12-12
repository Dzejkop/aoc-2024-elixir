defmodule Day9 do
  def part_one(f) do
    content = File.read!(f)
    data = parse_input(content)
    sorted = sort(data)
    checksum(sorted)
  end

  def parse_input(s) do
    parse_chars(0, true, String.codepoints(s))
  end

  def parse_chars(i, is_file, [x | xs]) do
    List.duplicate(
      if is_file do
        i
      else
        nil
      end,
      String.to_integer(x)
    ) ++
      parse_chars(
        if is_file do
          i + 1
        else
          i
        end,
        not is_file,
        xs
      )
  end

  def parse_chars(_, _, []) do
    []
  end

  def sort(lst) do
    arr = :array.from_list(lst)

    # TODO: Would be better to start and finish with an array but I'm lazy
    e = :array.size(arr) - 1
    sorted = sort(0, e, arr)

    sorted = :array.to_list(sorted)
    Enum.filter(sorted, & &1)
  end

  def sort(s, e, arr) when s == e do
    arr
  end

  def sort(s, e, arr) do
    if :array.get(s, arr) do
      sort(s + 1, e, arr)
    else
      if :array.get(e, arr) do
        sort(s, e, lswap(arr, s, e))
      else
        sort(s, e - 1, arr)
      end
    end
  end

  def checksum(lst) do
    checksum(0, lst)
  end

  def checksum(i, [x | xs]) do
    i * x + checksum(i + 1, xs)
  end

  def checksum(_, []) do
    0
  end

  def lswap(arr, a, b) do
    av = :array.get(a, arr)
    bv = :array.get(b, arr)

    arr = :array.set(a, bv, arr)
    arr = :array.set(b, av, arr)

    arr
  end
end
