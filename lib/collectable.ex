defimpl Collectable, for: EQueue do
  def into(queue = %EQueue{}), do: {queue, &into(&1, &2)} 

  defp into(queue = %EQueue{}, {:cont, item}), do: queue |> EQueue.push(item)
  defp into(queue = %EQueue{}, :done), do: queue
  defp into(_, :halt), do: nil
end
