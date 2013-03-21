lively
======

Lively manages a collection of dynamically changing elixir modules at runtime.

Modules are stored in a database (currently Couchbase 2.0). 

Why store your code in a database?  

This allows you to have a fully distributed platform, of homogenous servers, such that
to add capacity you just spin up a new server. This removes the step of deploying 
application code to every server. This way you can have an unlimited number of applications
with complex dependancies without the need for operations people to keep things going.  
Effectively it removes the deployment step for a distributed web platform, as every server
can fetch app code from the database and start serving requests immediately.

Why not store your code in a database?  You still have dependencies and possibly complexity,
but instead of depending on files being on a specific machine, you're depending on records 
being in the db.  This might prove to be much worse!

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

