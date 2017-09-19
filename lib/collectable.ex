defimpl Collectable, for: EQ do
  @doc """
  Allows you to push values into a queue following FIFO order

  == Examples
  iex> 1..5 |> Enum.into(EQ.new)
  #EQ<[1, 2, 3, 4, 5]>

  iex> 6..8 |> Enum.into(EQ.from_list([1,2]))
  #EQ<[1, 2, 6, 7, 8]>

  iex> %{a: :bear, b: :cute} |> Enum.into(EQ.new)
  #EQ<[a: :bear, b: :cute]>
  """
  def into(queue = %EQ{}), do: {queue, &into(&1, &2)} 

  defp into(queue = %EQ{}, {:cont, item}), do: queue |> EQ.push(item)
  defp into(queue = %EQ{}, :done), do: queue
  defp into(_, :halt), do: nil
end
