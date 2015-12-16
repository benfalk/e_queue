defmodule EQueueTest do
  use ExUnit.Case, async: true
  doctest EQueue
  doctest Collectable.EQueue
  doctest Enumerable.EQueue

  test "the truth" do
    assert 1 + 1 == 2
  end
end
