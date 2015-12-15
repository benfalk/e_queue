defimpl Inspect, for: EQueue do
  @spec inspect(EQueue.t, Keyword.t) :: String.t
  def inspect(queue = %EQueue{}, _opts) do
    "#EQueue<#{inspect EQueue.to_list(queue)}>"
  end
end
