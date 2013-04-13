

defrecord LivelyState, modules: nil


defmodule Lively do
	use Application.Behaviour

	def start(_type, mods) do
		state = LivelyState.new(modules: mods)
		Stacker.Supervisor.start_link(state)
	end


end


