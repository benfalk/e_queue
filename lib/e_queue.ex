defmodule EQueue do
  @moduledoc """
  A simple wrapper around the Erlang Queue library that follows the idiomatic
  pattern of expecting the module target first to take advantage of the pipeline
  operator.

  Queues are double ended. The mental picture of a queue is a line of people
  (items) waiting for their turn. The queue front is the end with the item that
  has waited the longest. The queue rear is the end an item enters when it
  starts to wait. If instead using the mental picture of a list, the front is
  called head and the rear is called tail.

  Entering at the front and exiting at the rear are reverse operations on the queue.
  """
  @type t :: {[any],[any]}


  @doc """
  Returns an empty queue

  == Example
  iex> EQueue.new
  {[],[]}
  """
  @spec new :: EQueue.t
  def new(), do: :queue.new


  @doc """
  Calculates and returns the length of given queue

  == Example
  iex> {[:a,:b],[:c]} |> EQueue.length
  3
  """
  @spec length(EQueue.t) :: pos_integer()
  def length(queue), do: :queue.len(queue)


  @doc """
  Adds an item to the end of the queue, returns the resulting queue

  == Example
  iex> EQueue.new |> EQueue.add(:a)
  {[:a],[]}
  """
  @spec add(EQueue.t, any) :: EQueue.t
  def add(queue, item), do: :queue.in(item, queue)


  @doc """
  Removes the item at the front of queue. Returns the tuple {:value, item, Q2},
  where item is the item removed and Q2 is the resulting queue. If Q1 is empty,
  the tuple {:empty, Q1} is returned.

  == Example
  iex> EQueue.new |> EQueue.add(:a) |> EQueue.add(:b) |> EQueue.take
  {:value, :a, {[],[:b]}}

  iex> EQueue.new |> EQueue.take
  {:empty, {[],[]}}
  """
  @spec take(EQueue.t) :: {:value, any, EQueue.t}
                        | {:empty, EQueue.t}
  def take(queue) do
    case :queue.out(queue) do
      {{:value, value}, new_queue} -> {:value, value, new_queue}
      {:empty, ^queue} -> {:empty, queue}
    end
  end


  @doc """
  Returns a list of the items in the queue in the same order;
  the front item of the queue will become the head of the list.

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.to_list
  [1, 2, 3, 4, 5]
  """
  @spec to_list(EQueue.t) :: [any]
  def to_list(queue), do: :queue.to_list(queue)


  @doc """
  Returns a queue containing the items in L in the same order;
  the head item of the list will become the front item of the queue.

  == Example
  iex> EQueue.from_list [1, 2, 3, 4, 5]
  {[5, 4], [1, 2, 3]}
  """
  @spec from_list([any]) :: EQueue.t
  def from_list(list), do: :queue.from_list(list)


  @doc """
  Returns a new queue with the items for the given queue in reverse order

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.reverse
  {[1, 2, 3], [5, 4]}
  """
  @spec reverse(EQueue.t) :: EQueue.t
  def reverse(queue), do: :queue.reverse(queue)


  @doc """
  With a given queue and an amount it returns {Q2, Q3}, where Q2 contains
  the amount given and Q2 holds the rest.  If attempted to split an empty
  queue or past the length an argument error is raised

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.split(3)
  {{[3], [1, 2]}, {[5], [4]}}

  iex> {[5, 4], [1, 2, 3]} |> EQueue.split(12)
  ** (ArgumentError) argument error
  """
  @spec split(EQueue.t, pos_integer()) :: {EQueue.t, EQueue.t}
  def split(queue, amount), do: :queue.split(amount, queue)


  @doc """
  Given two queues, an new queue is returned with the second appended to
  the end of the first queue given

  == Example
  iex> {[1], []} |> EQueue.join({[2], []})
  {[2], [1]}
  """
  @spec join(EQueue.t, EQueue.t) :: EQueue.t
  def join(front, back), do: :queue.join(front, back)


  @doc """
  With a given queue and function, a new queue is returned in the same
  order as the one given where the function returns true for an element

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.filter(fn x -> rem(x, 2) == 0 end)
  {[4], [2]}
  """
  @spec filter(EQueue.t, Fun) :: EQueue.t
  def filter(queue, fun), do: :queue.filter(fun, queue)


  @doc """
  Returns true if the given element is in the queue, false otherwise

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.member? 2
  true

  iex> {[5, 4], [1, 2, 3]} |> EQueue.member? 9
  false
  """
  @spec member?(EQueue.t, any) :: true | false
  def member?(queue, item), do: :queue.member(item, queue)


  @doc """
  Returns true if the given queue is empty, false otherwise

  == Example
  iex> {[5, 4], [1, 2, 3]} |> EQueue.empty?
  false

  iex> EQueue.new |> EQueue.empty?
  true
  """
  @spec empty?(EQueue.t) :: true | false
  def empty?(queue), do: :queue.is_empty(queue)


  @doc """
  Returns true if the given item is a queue, false otherwise

  iex> EQueue.new |> EQueue.is_queue?
  true

  iex> {:a_queue?, [], []} |> EQueue.is_queue?
  false
  """
  @spec is_queue?(any) :: true | false
  def is_queue?(item), do: :queue.is_queue(item)
end
