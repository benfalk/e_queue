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
  """
  @spec new :: EQueue.t
  def new(), do: :queue.new


  @doc """
  Calculates and returns the length of given queue
  """
  @spec length(EQueue.t) :: pos_integer()
  def length(queue), do: :queue.len(queue)


  @doc """
  Adds an item to the end of the queue, returns the resulting queue
  """
  @spec add(EQueue.t, any) :: EQueue.t
  def add(queue, item), do: :queue.in(item, queue)


  @doc """
  Removes the item at the front of queue. Returns the tuple {:value, item, Q2},
  where item is the item removed and Q2 is the resulting queue. If Q1 is empty,
  the tuple {:empty, Q1} is returned.
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
  """
  @spec to_list(EQueue.t) :: [any]
  def to_list(queue), do: :queue.to_list(queue)


  @doc """
  Returns a queue containing the items in L in the same order;
  the head item of the list will become the front item of the queue.
  """
  @spec from_list([any]) :: EQueue.t
  def from_list(list), do: :queue.from_list(list)


  @doc """
  Returns a new queue with the items for the given queue in reverse order
  """
  @spec reverse(EQueue.t) :: EQueue.t
  def reverse(queue), do: :queue.reverse(queue)


  @doc """
  With a given queue and an amount it returns {Q2, Q3}, where Q2 contains
  the amount given and Q2 holds the rest
  """
  @spec split(EQueue.t, pos_integer()) :: {EQueue.t, EQueue.t}
  def split(queue, amount), do: :queue.split(amount, queue)


  @doc """
  Given two queues, an new queue is returned with the second appended to
  the end of the first queue given
  """
  @spec join(EQueue.t, EQueue.t) :: EQueue.t
  def join(front, back), do: :queue.join(front, back)


  @doc """
  With a given queue and function, a new queue is returned in the same
  order as the one given where the function returns true for an element
  """
  @spec filter(EQueue.t, Fun) :: EQueue.t
  def filter(queue, fun), do: :queue.filter(fun, queue)


  @doc """
  Returns true if the given element is in the queue, false otherwise
  """
  @spec member?(EQueue.t, any) :: true | false
  def member?(queue, item), do: :queue.member(item, queue)


  @doc """
  Returns true if the given queue is empty, false otherwise
  """
  @spec empty?(EQueue.t) :: true | false
  def empty?(queue), do: :queue.is_empty(queue)


  @doc """
  Returns true if the given item is a queue, false otherwise
  """
  @spec is_queue?(any) :: true | false
  def is_queue?(item), do: :queue.is_queue(item)
end
