defimpl Enumerable, for: EQ do
  @empty_queue EQ.new

  @moduledoc """
  Provides access to all of the great Enum and Stream functions
  """

  @doc """
  iex> EQ.from_list([1, 2, 3]) |> Enum.member?(2)
  true

  iex> EQ.from_list([1, 2, 3]) |> Enum.member?(5)
  false
  """
  @spec member?(EQ.t, any) :: {:ok, true} | {:ok, false}
  def member?(queue = %EQ{}, term), do: {:ok, EQ.member?(queue, term)}


  @doc """
  == Example
  iex> EQ.from_list([1, 2, 3]) |> Stream.map(&(&1 * 2)) |> Enum.take(9)
  [2, 4, 6]
  """
  @spec reduce(EQ.t, Enum.acc, Enum.reducer) :: Enum.result
  def reduce(_,                 {:halt, acc},    _fun), do: {:halted, acc}
  def reduce(queue = %EQ{}, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(queue, &1, fun)}
  end
  def reduce(@empty_queue,      {:cont, acc}, _fun), do: {:done, acc}
  def reduce(queue = %EQ{}, {:cont, acc}, fun) do
    {{:value, item}, remaining} = EQ.pop(queue)
    reduce(remaining, fun.(item, acc), fun)
  end


  @doc """
  == Example
  iex> 1..30 |> Enum.to_list |> EQ.from_list |> Enum.count
  30
  """
  @spec count(EQ.t) :: {:ok, non_neg_integer}
  def count(queue = %EQ{}), do: {:ok, EQ.length(queue)}
end
