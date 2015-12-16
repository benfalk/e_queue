defimpl Collectable, for: EQueue do
  @doc """
  Allows you to push values into a queue following FIFO order

  == Examples
  iex> 1..5 |> Enum.into(EQueue.new)
  #EQueue<[1, 2, 3, 4, 5]>

  iex> 6..8 |> Enum.into(EQueue.from_list([1,2]))
  #EQueue<[1, 2, 6, 7, 8]>

  iex> %{a: :bear, b: :cute} |> Enum.into(EQueue.new)
  #EQueue<[a: :bear, b: :cute]>
  """
  def into(queue = %EQueue{}), do: {queue, &into(&1, &2)} 

  defp into(queue = %EQueue{}, {:cont, item}), do: queue |> EQueue.push(item)
  defp into(queue = %EQueue{}, :done), do: queue
  defp into(_, :halt), do: nil
end
