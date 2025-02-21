WORKER:
	Server ownership: check if any server is disconnected and set inactive
	if server is inactive, check if users are connected to them and balance between the servers connected
	add to server ownership log 
		connection CONNECTED
		connection DISCONNECTED
		Migration users: 
			remove from one server
			balance it all the servers availables 
		when is connected again:
			balance it all the servers available
		if no servers active log 
			shutdown server for : time 
	 qtask | qtask_user | qtask_action
	 qtask resolve the problem of concurrency for cron tasks (maitainance in system) 
	 	eg: remove from table a rows to send to a history table to archive it
	 	eg: block user when hits more 3 fail login
	 	eg: block user when hits more 100 request to endpoint
	 	eg: block user when try to access multiple times to uris he doesnt has access
	 qtask_user: resolve the problem of cron task of each user: giving them a "automation process control of their account"
	 	eg: send verify email
	 	eg: upgrade/downgrade account
	 	eg: process payment account
	 qtask_action has the action to be processed
