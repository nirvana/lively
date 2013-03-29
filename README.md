lively
======

Lively manages a collection of dynamically changing elixir modules at runtime.


## Module format at rest

Code expects modules to be in the form of hashdict returned from the DB, and will then parse them.

```
Expected format is something like:
{ 	type : "nirvana-module",
	language: "elixir",
	alpha: "tag for alpha version"
	beta: "tag for beta version"
	production: "tag for production version"

	code: 
	{
		"tag" : "defmodule ..."
	}


}
```

## RDD - Readme Driven Development

0. Add supervisor code from supr.

1. Basic support for reading code in from the DB and turning it into a running module in the beam VM.

2. Keep Modules Fresh - timer that fires every 15 seconds. Queries a view to see if there is any new code, or recently changed code. Checks to see if any of the new code is in its table, and if so, it updates it. We can see if the code is changed by keeping a copy of the CAS code that Couchbase gives us.

3. Manages versions - keeps multiple versions of code, and picks the right one based on query parameters.

4. Flushes old code - If a code version has not been requested in the past hour, it is flushed.

5. Views: Need two views: one to support looking up a module by key, status (dev/prod) or tag, a second that gives a list of views that have been touched in some period of time (depending on the query).

Jose's example:
```
	record   = get_record_from_database   #Raw text
	id       = record.id			   #variation
	contents = Code.string_to_ast!(record.body)	#turn the text into executable BEAM code
	#make correctly formated atom name (eg: Module.Submodule) to use when calling (and store it in a variable) 
	# -- the results of this need to be unique or it will trample other modules loaded into beam
	module   = Module.concat(FromDB, "Data#{record.id}") 
	# Make this module callable by other applications and processes under the previously determined
	Module.create module, contents, []  name.
```


purging old code:

delete(Module) -> boolean()

Types:

Module = module()
Removes the current code for Module, that is, the current code for Module is made old. This means that processes can continue to execute the code in the module, but that no external function calls can be made to it.

Returns true if successful, or false if there is old code for Module which must be purged first, or if Module is not a (loaded) module.

purge(Module) -> boolean()

Types:

Module = module()
Purges the code for Module, that is, removes code marked as old. If some processes still linger in the old code, these processes are killed before the code is removed.

Returns true if successful and any process needed to be killed, otherwise false.

soft_purge(Module) -> boolean()

Types:

Module = module()
Purges the code for Module, that is, removes code marked as old, but only if no processes linger in it.

Returns false if the module could not be purged due to processes lingering in old code, otherwise true.





