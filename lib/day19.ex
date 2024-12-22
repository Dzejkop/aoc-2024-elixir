defmodule Day19 do
  def part_one(f) do
    content = File.read!(f)

    [towels, designs] = String.split(content, "\n\n")

    towels = parse_available_towels(String.trim(towels))
    designs = parse_designs(String.trim(designs))

    towels = MapSet.new(towels)

    Enum.count(designs, fn design ->
      p = Task.async(fn -> possible?(design, towels) end)
      i = Task.async(fn -> not impossible?(design, towels) end)

      out = Task.yield_many([p, i], timeout: :infinity)
      dbg(out)
      [{_winner, {:ok, result}} | rest] = out

      Enum.each(rest, fn {task, _} -> Task.shutdown(task, :brutal_kill) end)

      result
    end)
  end

  def parse_available_towels(s) do
    String.split(s, ",") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
  end

  def parse_designs(s) do
    String.split(s, "\n") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
  end

  def possible?(design, towels) do
    nmax = Enum.map(towels, &String.length/1) |> Enum.max()
    towels = MapSet.new(towels)

    possible?(design, towels, nmax)
  end

  def possible?("", _, _) do
    true
  end

  def possible?(design, towels, nmax) do
    if MapSet.member?(towels, design) do
      true
    else
      not Enum.all?(nmax..1//-1, fn prefix_len -> 

      end)
      # Enum.any?(nmax..1//-1, fn prefix_len ->
      #   {prefix, rem} = String.split_at(design, prefix_len)

      #   if MapSet.member?(towels, prefix) do
      #     possible?(rem, towels, nmax)
      #   else
      #     false
      #   end
      # end)
    end
  end

  def impossible?(design, towels) do
    nmax = Enum.map(towels, &String.length/1) |> Enum.max()
    towels = MapSet.new(towels)

    impossible?(design, towels, nmax)
  end

  def impossible?("", _, _) do
    false
  end


  def impossible?(design, towels, nmax) do
    if MapSet.member?(towels, design) do
      false
    else
      Enum.all?(nmax..1//-1, fn prefix_len -> 
        {prefix, rem} = String.split_at(design, prefix_len)

        if MapSet.member?(towels, prefix) do
          impossible?(rem, towels, nmax)
        else
          true
        end
      end) 
    end
  end
end
