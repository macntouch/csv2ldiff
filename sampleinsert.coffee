uuid = require 'node-uuid'
csv2ldif = require "./csv2ldif"

config = 

	"dn": (record) ->
		
		username = record.username.replace ",", ""
		username = username.replace "+", ""
		"cn=#{username},ou=People,dc=my-dc,dc=com"
	"changetype": -> "add"
	"cn": "username"
	"userPassword": "password"
	"objectClass": ->
			"myObjectClass"
	"uid": -> uuid.v4()
	"givenName": (record) ->
			record.firstname || record.name
	"sn": (record) ->
		record.lastname || record.name
	"title": "academicTitle"
	"mail": "email"
	"telephoneNumber": "phone"
	"mobile": "mobile"
	"street": "address"
	"postalCode": "zipCode"
	"l": "city"
	"st": "state"


usedUsernames = {}


csv2ldif 
	skipFunction: (record) ->
		username = record.username.toLowerCase()

		if usedUsernames[username]?
			console.log "# "	
			console.log "# skipped #{username}"
			console.log "# "
			true
		else	
			usedUsernames[username] = true
			false

	ldifConfig: config
	inStream: process.stdin
	outStream: process.stdout
	parseOptions: delimiter: ";"
	