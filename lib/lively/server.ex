defmodule Lively.Server do
  use GenServer.Behaviour

  @moduledoc """
  OTP Application that manages loaded Elixir modules. 
  This code allows you to dynamically load Elixir modules from some data source (eg: a couchbase).
  
   """
   
  def init(context) do
    { :ok, context }
  end

  @doc """
  		Reqeust Module - looks up in ETS table to see if it has the magic cookie, and if so, 
		returns the magic cookie. If not, it loads the module from the database, and if it 
		can't find it, then returns :notfound

  		Takes parameters - the name of the module, the status (beta, etc), Tags and versions. 
		If version is given it loads that version, if not, then by tag, if no tag then by quality 
		(the latest beta), and if no quality given then the latest prod quality match, or if 
		there are none marked prod then it will give the latest version of any kind.

  		Returns the magic cookie.  This is the output of Module.concat/2
	"""
  def handle_call(:pop, _from, [h|stack]) do #name, status, tag, version, context
    { :reply, h, stack }
  end

  def handle_cast({ :push, new }, stack) do
    { :noreply, [new|stack] }
  end
end