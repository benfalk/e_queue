defmodule EQ.Mixfile do
  use Mix.Project

  def project do
    [app: :e_q,
     version: "1.0.0",
     elixir: "~> 1.1",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp description do
    """
    An Elixir wrapper around the Erlang optimized `queue` that supports the FIFO,
    first-in first-out, pattern.  This is useful is when you can't predict when an
    item needs to be taken or added to the queue.  Use this instead of using `++` or
    double reversing lists to add items to the "back" of a queue.
    """
  end

  defp package do
    [
      name: "e_q",
      maintainers: ["Christopher Bertels"],
      links: %{"GitHub" => "https://github.com/bakkdoor/e_q"},
      licenses: ["MIT License"]
    ]
  end
end
