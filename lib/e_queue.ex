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

  defstruct data: :queue.new
  @type t :: %EQueue{data: {[any],[any]} }

  @doc """
  Returns an empty queue

  ## Example
      iex> EQueue.new
      #EQueue<[]>
  """
  @spec new :: EQueue.t
  def new(), do: %EQueue{}


  @doc """
  Calculates and returns the length of given queue

  ## Example
      iex> EQueue.from_list([:a, :b, :c]) |> EQueue.length
      3
  """
  @spec length(EQueue.t) :: pos_integer()
  def length(%EQueue{data: queue}), do: :queue.len(queue)


  @doc """
  Adds an item to the end of the queue, returns the resulting queue

  ## Example
      iex> EQueue.new |> EQueue.push(:a)
      #EQueue<[:a]>
  """
  @spec push(EQueue.t, any) :: EQueue.t
  def push(%EQueue{data: queue}, item), do: :queue.in(item, queue) |> wrap


  @doc """
  Removes the item at the front of queue. Returns the tuple `{{:value, item}, Q2}`,
  where item is the item removed and Q2 is the resulting queue. If Q1 is empty,
  the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQueue.from_list([:a, :b]) |> EQueue.pop
      {{:value, :a}, %EQueue{data: {[], [:b]} }}

      iex> EQueue.new |> EQueue.pop
      {:empty, EQueue.new}
  """
  @spec pop(EQueue.t) :: {{:value, any}, EQueue.t}
                        | {:empty, EQueue.t}
  def pop(%EQueue{data: queue}) do
    case :queue.out(queue) do
      {val, queue} -> {val, wrap(queue)}
    end
  end


  @doc """
  Returns a list of the items in the queue in the same order;
  the front item of the queue will become the head of the list.

  ## Example
      iex> EQueue.from_list([1, 2, 3, 4, 5]) |> EQueue.to_list
      [1, 2, 3, 4, 5]
  """
  @spec to_list(EQueue.t) :: [any]
  def to_list(%EQueue{data: queue}), do: :queue.to_list(queue)


  @doc """
  Returns a queue containing the items in L in the same order;
  the head item of the list will become the front item of the queue.

  ## Example
      iex> EQueue.from_list [1, 2, 3, 4, 5]
      #EQueue<[1, 2, 3, 4, 5]>
  """
  @spec from_list([any]) :: EQueue.t
  def from_list(list), do: :queue.from_list(list) |> wrap


  @doc """
  Returns a new queue with the items for the given queue in reverse order

  ## Example
      iex> EQueue.from_list([1, 2, 3, 4, 5]) |> EQueue.reverse
      #EQueue<[5, 4, 3, 2, 1]>
  """
  @spec reverse(EQueue.t) :: EQueue.t
  def reverse(%EQueue{data: queue}), do: :queue.reverse(queue) |> wrap


  @doc """
  With a given queue and an amount it returns {Q2, Q3}, where Q2 contains
  the amount given and Q2 holds the rest.  If attempted to split an empty
  queue or past the length an argument error is raised

  ## Examples
      iex> EQueue.from_list([1, 2, 3, 4, 5]) |> EQueue.split(3)
      {EQueue.from_list([1,2,3]), EQueue.from_list([4,5])}

      iex> EQueue.from_list([1, 2, 3, 4, 5]) |> EQueue.split(12)
      ** (ArgumentError) argument error
  """
  @spec split(EQueue.t, pos_integer()) :: {EQueue.t, EQueue.t}
  def split(%EQueue{data: queue}, amount) do
    {left, right} = :queue.split(amount, queue)
    {wrap(left), wrap(right)}
  end


  @doc """
  Given two queues, an new queue is returned with the second appended to
  the end of the first queue given

  ## Example
      iex> EQueue.from_list([1]) |> EQueue.join(EQueue.from_list([2]))
      #EQueue<[1, 2]>
  """
  @spec join(EQueue.t, EQueue.t) :: EQueue.t
  def join(%EQueue{data: front}, %EQueue{data: back}) do
    :queue.join(front, back) |> wrap
  end


  @doc """
  With a given queue and function, a new queue is returned in the same
  order as the one given where the function returns true for an element

  ## Example
      iex> EQueue.from_list([1, 2, 3, 4, 5]) |> EQueue.filter(fn x -> rem(x, 2) == 0 end)
      #EQueue<[2, 4]>
  """
  @spec filter(EQueue.t, Fun) :: EQueue.t
  def filter(%EQueue{data: queue}, fun), do: :queue.filter(fun, queue) |> wrap


  @doc """
  Returns true if the given element is in the queue, false otherwise

  ## Examples
      iex> EQueue.from_list([1, 2, 3]) |> EQueue.member? 2
      true

      iex> EQueue.from_list([1, 2, 3]) |> EQueue.member? 9
      false
  """
  @spec member?(EQueue.t, any) :: true | false
  def member?(%EQueue{data: queue}, item), do: :queue.member(item, queue)


  @doc """
  Returns true if the given queue is empty, false otherwise

  ## Examples
      iex> EQueue.from_list([1, 2, 3]) |> EQueue.empty?
      false

      iex> EQueue.new |> EQueue.empty?
      true
  """
  @spec empty?(EQueue.t) :: true | false
  def empty?(%EQueue{data: queue}), do: :queue.is_empty(queue)


  @doc """
  Returns true if the given item is a queue, false otherwise

  ## Examples
      iex> EQueue.new |> EQueue.is_queue?
      true

      iex> {:a_queue?, [], []} |> EQueue.is_queue?
      false
  """
  @spec is_queue?(any) :: true | false
  def is_queue?(%EQueue{data: queue}), do: :queue.is_queue(queue)
  def is_queue?(_), do: false


  @doc """
  Returns the item at the front of the queue.
  Returns the tuple `{{:value, item}, Q1}`.
  If Q1 is empty, the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQueue.from_list([1, 2]) |> EQueue.head
      {{:value, 1}, EQueue.from_list([1, 2]) }

      iex> EQueue.from_list([1]) |> EQueue.head
      {{:value, 1}, EQueue.from_list([1])}

      iex> EQueue.new |> EQueue.head
      {:empty, EQueue.new}
  """
  @spec head(EQueue.t) :: {{:value, any}, EQueue.t}
                        | {:empty, EQueue.t}
  def head(q = %EQueue{data: data}) do
    if q |> empty? do
      {:empty, q}
    else
      {{:value, :queue.head(data)}, q}
    end
  end


  @doc """
  Returns the item at the end of the queue.
  Returns the tuple `{{:value, item}, Q1}`.
  If Q1 is empty, the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQueue.from_list([1, 2]) |> EQueue.last
      {{:value, 2}, EQueue.from_list([1, 2]) }

      iex> EQueue.from_list([1]) |> EQueue.last
      {{:value, 1}, EQueue.from_list([1]) }

      iex> EQueue.new |> EQueue.last
      {:empty, EQueue.new}
  """
  @spec last(EQueue.t) :: {{:value, any}, EQueue.t}
                        | {:empty, EQueue.t}
  def last(q = %EQueue{data: data}) do
    if q |> empty? do
      {:empty, q}
    else
      {{:value, :queue.last(data)}, q}
    end
  end


  @doc """
  Removes the item at the front of the queue, returns the resulting queue.

  ## Example
      iex> EQueue.from_list([1,2,3]) |> EQueue.tail
      #EQueue<[2, 3]>

      iex> EQueue.from_list([1,2]) |> EQueue.tail
      #EQueue<[2]>

      iex> EQueue.from_list([1]) |> EQueue.tail
      #EQueue<[]>

      iex> EQueue.new |> EQueue.tail
      #EQueue<[]>
  """
  @spec tail(EQueue.t) :: EQueue.t
  def tail(q = %EQueue{data: queue}) do
    if q |> empty? do
      q
    else
      :queue.tail(queue) |> wrap
    end
  end


  @doc false
  @spec wrap({[any], [any]}) :: EQueue.t
  defp wrap(data), do: %EQueue{data: data}
end
