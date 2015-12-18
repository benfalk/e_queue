# EQueue

[![Build Status](https://travis-ci.org/benfalk/e_queue.svg?branch=master)](https://travis-ci.org/benfalk/e_queue)

## Description

An Elixir wrapper around the Erlang optimized `queue` that supports the FIFO,
first-in first-out, pattern.  This is useful is when you can't predict when an
item needs to be taken or added to the queue.  Use this instead of using `++` or
double reversing lists to add items to the _"back"_ of a queue.

This is the results of pushing 100k elements onto a list and poping every 13th
element off of it ( over 100x faster! )

``` elixir
# mix run test/performance.exs

IO.puts "#{inspect :timer.tc(EQueue.Performance, :test_queue, [[]])}"
#> {21163189, :ok}

IO.puts "#{inspect :timer.tc(EQueue.Performance, :test_queue, [EQueue.new])}"
#> {189986, :ok}
```

## Installation

  1. Add e_queue to your list of dependencies in `mix.exs`:

        def deps do
          [{:e_queue, "~> 1.0.0"}]
        end
