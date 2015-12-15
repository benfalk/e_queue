defimpl Enumerable, for: EQueue do
  @empty_queue EQueue.new

  def member?(queue = %EQueue{}, term), do: {:ok, EQueue.member?(queue, term)}
  
  def reduce(_,                 {:halt, acc},    _fun), do: {:halted, acc}
  def reduce(queue = %EQueue{}, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(queue, &1, fun)}
  end
  def reduce(@empty_queue,      {:cont, acc}, _fun), do: {:done, acc}
  def reduce(queue = %EQueue{}, {:cont, acc}, fun) do
    {:value, item, remaining} = EQueue.pop(queue)
    reduce(remaining, fun.(item, acc), fun)
  end

  def count(queue = %EQueue{}), do: EQueue.length(queue)
end
