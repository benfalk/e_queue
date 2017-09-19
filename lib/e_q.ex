defmodule EQ do
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
  @type t :: %EQ{data: {[any],[any]} }

  @doc """
  Returns an empty queue

  ## Example
      iex> EQ.new
      #EQ<[]>
  """
  @spec new :: EQ.t
  def new(), do: %EQ{}


  @doc """
  Calculates and returns the length of given queue

  ## Example
      iex> EQ.from_list([:a, :b, :c]) |> EQ.length
      3
  """
  @spec length(EQ.t) :: pos_integer()
  def length(%EQ{data: queue}), do: :queue.len(queue)


  @doc """
  Adds an item to the end of the queue, returns the resulting queue

  ## Example
      iex> EQ.new |> EQ.push(:a)
      #EQ<[:a]>
  """
  @spec push(EQ.t, any) :: EQ.t
  def push(%EQ{data: queue}, item), do: :queue.in(item, queue) |> wrap


  @doc """
  Removes the item at the front of queue. Returns the tuple `{{:value, item}, Q2}`,
  where item is the item removed and Q2 is the resulting queue. If Q1 is empty,
  the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQ.from_list([:a, :b]) |> EQ.pop
      {{:value, :a}, %EQ{data: {[], [:b]} }}

      iex> EQ.new |> EQ.pop
      {:empty, EQ.new}
  """
  @spec pop(EQ.t) :: {{:value, any}, EQ.t}
                        | {:empty, EQ.t}
  def pop(%EQ{data: queue}) do
    case :queue.out(queue) do
      {val, queue} -> {val, wrap(queue)}
    end
  end


  @doc """
  Returns a list of the items in the queue in the same order;
  the front item of the queue will become the head of the list.

  ## Example
      iex> EQ.from_list([1, 2, 3, 4, 5]) |> EQ.to_list
      [1, 2, 3, 4, 5]
  """
  @spec to_list(EQ.t) :: [any]
  def to_list(%EQ{data: queue}), do: :queue.to_list(queue)


  @doc """
  Returns a queue containing the items in L in the same order;
  the head item of the list will become the front item of the queue.

  ## Example
      iex> EQ.from_list [1, 2, 3, 4, 5]
      #EQ<[1, 2, 3, 4, 5]>
  """
  @spec from_list([any]) :: EQ.t
  def from_list(list), do: :queue.from_list(list) |> wrap


  @doc """
  Returns a new queue with the items for the given queue in reverse order

  ## Example
      iex> EQ.from_list([1, 2, 3, 4, 5]) |> EQ.reverse
      #EQ<[5, 4, 3, 2, 1]>
  """
  @spec reverse(EQ.t) :: EQ.t
  def reverse(%EQ{data: queue}), do: :queue.reverse(queue) |> wrap


  @doc """
  With a given queue and an amount it returns {Q2, Q3}, where Q2 contains
  the amount given and Q2 holds the rest.  If attempted to split an empty
  queue or past the length an argument error is raised

  ## Examples
      iex> EQ.from_list([1, 2, 3, 4, 5]) |> EQ.split(3)
      {EQ.from_list([1,2,3]), EQ.from_list([4,5])}

      iex> EQ.from_list([1, 2, 3, 4, 5]) |> EQ.split(12)
      ** (ArgumentError) argument error
  """
  @spec split(EQ.t, pos_integer()) :: {EQ.t, EQ.t}
  def split(%EQ{data: queue}, amount) do
    {left, right} = :queue.split(amount, queue)
    {wrap(left), wrap(right)}
  end


  @doc """
  Given two queues, an new queue is returned with the second appended to
  the end of the first queue given

  ## Example
      iex> EQ.from_list([1]) |> EQ.join(EQ.from_list([2]))
      #EQ<[1, 2]>
  """
  @spec join(EQ.t, EQ.t) :: EQ.t
  def join(%EQ{data: front}, %EQ{data: back}) do
    :queue.join(front, back) |> wrap
  end


  @doc """
  With a given queue and function, a new queue is returned in the same
  order as the one given where the function returns true for an element

  ## Example
      iex> [1, 2, 3, 4, 5] |> EQ.from_list |> EQ.filter(fn x -> rem(x, 2) == 0 end)
      #EQ<[2, 4]>
  """
  @spec filter(EQ.t, Fun) :: EQ.t
  def filter(%EQ{data: queue}, fun), do: :queue.filter(fun, queue) |> wrap


  @doc """
  Returns true if the given element is in the queue, false otherwise

  ## Examples
      iex> EQ.from_list([1, 2, 3]) |> EQ.member?(2)
      true

      iex> EQ.from_list([1, 2, 3]) |> EQ.member?(9)
      false
  """
  @spec member?(EQ.t, any) :: true | false
  def member?(%EQ{data: queue}, item), do: :queue.member(item, queue)


  @doc """
  Returns true if the given queue is empty, false otherwise

  ## Examples
      iex> EQ.from_list([1, 2, 3]) |> EQ.empty?
      false

      iex> EQ.new |> EQ.empty?
      true
  """
  @spec empty?(EQ.t) :: true | false
  def empty?(%EQ{data: queue}), do: :queue.is_empty(queue)


  @doc """
  Returns true if the given item is a queue, false otherwise

  ## Examples
      iex> EQ.new |> EQ.is_queue?
      true

      iex> {:a_queue?, [], []} |> EQ.is_queue?
      false
  """
  @spec is_queue?(any) :: true | false
  def is_queue?(%EQ{data: queue}), do: :queue.is_queue(queue)
  def is_queue?(_), do: false


  @doc """
  Returns the item at the front of the queue.
  Returns the tuple `{:value, item}``.
  If Q1 is empty, the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQ.from_list([1, 2]) |> EQ.head
      {:value, 1}

      iex> EQ.from_list([1]) |> EQ.head
      {:value, 1}

      iex> EQ.new |> EQ.head
      {:empty, EQ.new}
  """
  @spec head(EQ.t) :: {:value, any}
                        | {:empty, EQ.t}
  def head(q = %EQ{data: data}) do
    if q |> empty? do
      {:empty, q}
    else
      {:value, :queue.head(data)}
    end
  end


  @doc """
  Returns the item at the end of the queue.
  Returns the tuple `{:value, item}`.
  If Q1 is empty, the tuple `{:empty, Q1}` is returned.

  ## Examples
      iex> EQ.from_list([1, 2]) |> EQ.last
      {:value, 2}

      iex> EQ.from_list([1]) |> EQ.last
      {:value, 1}

      iex> EQ.new |> EQ.last
      {:empty, EQ.new}
  """
  @spec last(EQ.t) :: {:value, any}
                        | {:empty, EQ.t}
  def last(q = %EQ{data: data}) do
    if q |> empty? do
      {:empty, q}
    else
      {:value, :queue.last(data)}
    end
  end


  @doc """
  Removes the item at the front of the queue, returns the resulting queue.

  ## Example
      iex> EQ.from_list([1,2,3]) |> EQ.tail
      #EQ<[2, 3]>

      iex> EQ.from_list([1,2]) |> EQ.tail
      #EQ<[2]>

      iex> EQ.from_list([1]) |> EQ.tail
      #EQ<[]>

      iex> EQ.new |> EQ.tail
      #EQ<[]>
  """
  @spec tail(EQ.t) :: EQ.t
  def tail(q = %EQ{data: queue}) do
    if q |> empty? do
      q
    else
      :queue.tail(queue) |> wrap
    end
  end


  @doc false
  @spec wrap({[any], [any]}) :: EQ.t
  defp wrap(data), do: %EQ{data: data}
end
