defmodule Day19 do
  def part_one(f) do
    content = File.read!(f)

    [towels, designs] = String.split(content, "\n\n")

    towels = parse_available_towels(String.trim(towels))
    designs = parse_designs(String.trim(designs))

    Enum.count(designs, &possible?(&1, towels))
  end

  def part_two(f) do
    content = File.read!(f)

    [towels, designs] = String.split(content, "\n\n")

    towels = parse_available_towels(String.trim(towels))
    designs = parse_designs(String.trim(designs))

    {:ok, agent} = Day19.State.start_link()

    for towel <- towels do
      Day19.State.add_possible(towel)
    end

    possible_designs = Enum.filter(designs, &possible?(&1, towels))

    {:ok, counter_agent} = Day19.Counter.start_link()

    how_many_ways_to_make =
      Enum.map(possible_designs, &all_ways_to_make(&1, towels)) |> Enum.sum()

    Agent.stop(agent)
    Agent.stop(counter_agent)

    how_many_ways_to_make
  end

  def all_ways_to_make("", _), do: 1

  def all_ways_to_make(design, towels) do
    case Day19.Counter.get(design) do
      nil ->
        n =
          Enum.map(towels, fn towel ->
            if String.starts_with?(design, towel) do
              split = String.length(towel)
              {_, rem} = String.split_at(design, split)

              all_ways_to_make(rem, towels)
            else
              0
            end
          end)
          |> Enum.sum()

        Day19.Counter.put(design, n)

        n

      v ->
        v
    end
  end

  def possible?(design, towels) do
    nmax = Enum.map(towels, &String.length/1) |> Enum.max()

    possible_inner?(nmax, design)
  end

  def possible_inner?(nmax, design) do
    cond do
      Day19.State.is_possible?(design) ->
        true

      Day19.State.is_impossible?(design) ->
        false

      true ->
        prefixes = nmax..1//-1

        res =
          Enum.any?(prefixes, fn prefix_len ->
            {prefix, rem} = String.split_at(design, prefix_len)

            if Day19.State.is_possible?(prefix) do
              possible_inner?(nmax, rem)
            else
              false
            end
          end)

        if res do
          Day19.State.add_possible(design)
        else
          Day19.State.add_impossible(design)
        end

        res
    end
  end

  def parse_available_towels(s) do
    String.split(s, ",") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
  end

  def parse_designs(s) do
    String.split(s, "\n") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))
  end
end

defmodule Day19.State do
  use Agent

  def start_link() do
    state = %{
      possible: MapSet.new(),
      impossible: MapSet.new()
    }

    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def add_possible(new_possible) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, :possible, fn possible -> MapSet.put(possible, new_possible) end)
    end)
  end

  def add_impossible(new_impossible) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, :impossible, fn impossible -> MapSet.put(impossible, new_impossible) end)
    end)
  end

  def is_possible?(v) do
    Agent.get(__MODULE__, fn state -> MapSet.member?(state.possible, v) end)
  end

  def is_impossible?(v) do
    Agent.get(__MODULE__, fn state -> MapSet.member?(state.impossible, v) end)
  end
end

defmodule Day19.Counter do
  def start_link() do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  def get(k) do
    Agent.get(__MODULE__, fn map -> Map.get(map, k) end)
  end

  def put(k, v) do
    Agent.update(__MODULE__, fn map -> Map.update(map, k, v, fn ov -> ov + v end) end)
  end
end
