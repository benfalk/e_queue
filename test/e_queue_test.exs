defmodule EQTest do
  use ExUnit.Case, async: true
  doctest EQ
  doctest Collectable.EQ
  doctest Enumerable.EQ

  test "the truth" do
    assert 1 + 1 == 2
  end
end
