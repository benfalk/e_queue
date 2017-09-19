defmodule EQ.Performance do
  @times 1..100_000

  def compare do
    IO.puts "#{inspect :timer.tc(EQ.Performance, :test_queue, [[]])}"
    IO.puts "#{inspect :timer.tc(EQ.Performance, :test_queue, [EQ.new])}"
  end

  def test_queue(collection) do
    {:ok, queue} = Agent.start_link fn -> collection end
    Enum.each(@times, fn item ->
      case rem(item, 13) == 0 do
        true -> pop_agent(queue)
        false -> Agent.update(queue, &push(&1, item))
      end
    end)
    Agent.stop(queue)
  end

  defp pop([]), do: {:empty, []}
  defp pop([h|t] = from) when is_list(from), do: {{:value, h}, t}
  defp pop(queue = %EQ{}), do: EQ.pop(queue)

  defp pop_agent(agent), do: Agent.get_and_update(agent, fn state ->
    case pop(state) do
      {{:value, item}, queue} -> {item, queue}
      {:empty, queue} -> {:empty, queue}
    end
  end)

  defp push(collection, item) when is_list(collection), do: collection ++ [item]
  defp push(collection = %EQ{}, item), do: EQ.push(collection, item)
end

EQ.Performance.compare
