defimpl Inspect, for: EQ do
  @spec inspect(EQ.t, Keyword.t) :: String.t
  def inspect(queue = %EQ{}, _opts) do
    "#EQ<#{inspect EQ.to_list(queue)}>"
  end
end
