defmodule Day5 do
  def part_one(filename) do
    content = File.read!(filename)

    {pos, _} = :binary.match(content, "\n\n")

    rules = String.slice(content, 0, pos)
    pages = String.slice(content, pos + 2, String.length(content))

    rules = parse_rules(rules)
    pages = parse_pages(pages)

    valid_pages = Enum.filter(pages, &valid_page(&1, rules))

    middle_vals =
      Enum.map(valid_pages, fn page ->
        m = floor(length(page) / 2)

        Enum.at(page, m)
      end)

    sum = Enum.sum(middle_vals)

    IO.puts("#{sum}")
  end

  def part_two(filename) do
    content = File.read!(filename)

    {pos, _} = :binary.match(content, "\n\n")

    rules = String.slice(content, 0, pos)
    pages = String.slice(content, pos + 2, String.length(content))

    rules = parse_rules(rules)
    pages = parse_pages(pages)

    invalid_pages = Enum.filter(pages, &(!valid_page(&1, rules)))

    revalidated_pages = Enum.map(invalid_pages, &reorder_page(&1, rules))

    middle_vals =
      Enum.map(revalidated_pages, fn page ->
        m = floor(length(page) / 2)

        Enum.at(page, m)
      end)

    sum = Enum.sum(middle_vals)

    IO.puts("#{sum}")
  end

  def parse_rules(rules_str) do
    rules =
      for s <- String.split(rules_str, "\n") do
        [l, r] = String.split(s, "|")

        {String.to_integer(l), String.to_integer(r)}
      end

    # We invert the rule set here
    rules =
      Enum.group_by(rules, &elem(&1, 1), &elem(&1, 0))
      |> Enum.map(fn {key, value} -> {key, Enum.sort(value)} end)
      |> Enum.into(%{})

    rules
  end

  def parse_pages(pages_str) do
    for s <- String.split(pages_str, "\n") do
      String.split(s, ",") |> Enum.map(&String.to_integer/1)
    end
  end

  def valid_page([h | page], rules) do
    case Map.get(rules, h) do
      nil -> true
      n_rules -> validate_page_successors(h, page, n_rules)
    end and valid_page(page, rules)
  end

  def valid_page([], _rules) do
    true
  end

  def validate_page_successors(n, [s | page], n_rules) do
    !Enum.any?(n_rules, &(&1 == s)) and validate_page_successors(n, page, n_rules)
  end

  def validate_page_successors(_, [], _) do
    true
  end

  def reorder_page([n | page], rules) do
    case Map.get(rules, n) do
      nil ->
        [n | reorder_page(page, rules)]

      n_rules ->
        case find_invalid_successor(page, n_rules) do
          nil ->
            [n | reorder_page(page, rules)]

          invalid ->
            q = Enum.at(page, invalid)
            new_page = List.replace_at(page, invalid, n)

            reorder_page([q | new_page], rules)
        end
    end
  end

  def reorder_page([], _) do
    []
  end

  def find_invalid_successor(page, invalid_successors) do
    Enum.find_index(page, fn n ->
      Enum.any?(invalid_successors, fn q -> n == q end)
    end)
  end

  def swap(list, il, ir) do
    el = Enum.at(list, il)
    er = Enum.at(list, ir)

    list |> List.replace_at(il, er) |> List.replace_at(ir, el)
  end
end
