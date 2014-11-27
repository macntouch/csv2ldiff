



ldif = 

	"dn": -> "cn=partner-net,ou=Groups,dc=hamilton-medical,dc=com"
	"changetype": -> "modify"
	"add": -> "member"


	"member": (record) -> 
		
		username = record.username.replace ",", ""
		username = username.replace "+", ""
		"cn=#{username},ou=People,dc=hamilton-medical,dc=com"


usedUsernames = {}

skipFunction =  (record) ->
	username = record.username.toLowerCase()
	if usedUsernames[username]?
		console.log "# "
		console.log "# skipped #{username}"
		console.log "# "
		true
	else
		usedUsernames[username] = true
		false

csv2ldif = require "./csv2ldif"
csv2ldif
	skipFunction: skipFunction
	ldifConfig: ldif
	inStream: process.stdin
	outStream: process.stdout
	parseOptions: delimiter: ";"