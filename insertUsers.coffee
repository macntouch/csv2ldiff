uuid = require 'node-uuid'

config = 

	"dn": (record) ->
		
		username = record.username.replace ",", ""
		username = username.replace "+", ""
		"cn=#{username},ou=People,dc=hamilton-medical,dc=com"
	"changetype": -> "add"
	"objectClass": ->
			"x-mgnl-User"
	"uid": -> uuid.v4()
	"x-mgnl-gender": "gender"
	"givenName": (record) ->
			record.firstname || record.name || record.username
	"sn": (record) ->
		record.lastname || record.name || record.username
	"title": "academicTitle"
	"x-mgnl-profession": "profession"
	"mail": "email"
	"telephoneNumber": "phone"
	"mobile": "mobile"
	"x-mgnl-company": "company"
	"departmentNumber": "department"
	"x-mgnl-function": "function"
	"x-mgnl-position": "position"
	"street": "address"
	"postalCode": "zipCode"
	"l": "city"
	"st": "state"
	"x-mgnl-country": "country"
	"preferredLanguage": "language"
	"cn": "username"
	"userPassword": "password"
	"x-mgnl-aarcMemberID": "aarcMemberID"
	"x-mgnl-aarcResidence": "aarcResidence"
	"x-mgnl-usedVents": "usedVents"


usedUsernames = {}
csv2ldif = require "./csv2ldif"

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