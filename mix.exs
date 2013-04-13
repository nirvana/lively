defmodule Lively.Mixfile do
  use Mix.Project

  def project do
    [ app: :lively,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do

    [ registered: [:lively],
      mod: { Lively, [] } ]
 end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do 
	[ 
    {:couchie, github: "nirvana/couchie"},
    {:amnesic, github: "nirvana/amnesic"}     
	]
  end
end
