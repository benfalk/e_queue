defimpl Enumerable, for: EQueue do
  @empty_queue EQueue.new

  @moduledoc """
  Provides access to all of the great Enum and Stream functions
  """

  @doc """
  iex> EQueue.from_list([1, 2, 3]) |> Enum.member?(2)
  true

  iex> EQueue.from_list([1, 2, 3]) |> Enum.member?(5)
  false
  """
  @spec member?(EQueue.t, any) :: {:ok, true} | {:ok, false}
  def member?(queue = %EQueue{}, term), do: {:ok, EQueue.member?(queue, term)}


  @doc """
  == Example
  iex> EQueue.from_list([1, 2, 3]) |> Stream.map(&(&1 * 2)) |> Enum.take(9)
  [2, 4, 6]
  """
  @spec reduce(EQueue.t, Enum.acc, Enum.reducer) :: Enum.result
  def reduce(_,                 {:halt, acc},    _fun), do: {:halted, acc}
  def reduce(queue = %EQueue{}, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(queue, &1, fun)}
  end
  def reduce(@empty_queue,      {:cont, acc}, _fun), do: {:done, acc}
  def reduce(queue = %EQueue{}, {:cont, acc}, fun) do
    {{:value, item}, remaining} = EQueue.pop(queue)
    reduce(remaining, fun.(item, acc), fun)
  end


  @doc """
  == Example
  iex> 1..30 |> Enum.to_list |> EQueue.from_list |> Enum.count
  30
  """
  @spec count(EQueue.t) :: {:ok, non_neg_integer}
  def count(queue = %EQueue{}), do: {:ok, EQueue.length(queue)}
end
