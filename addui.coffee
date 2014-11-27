

uuid = require 'node-uuid'

ldif = 

	"dn": (record) ->
		
		username = record.username.replace ",", ""
		username = username.replace "+", ""
		"cn=#{username},ou=People,dc=hamilton-medical,dc=com"
	"changetype": -> "modify"
	"add": -> "uid"


	"uid": -> uuid.v4()

csv2ldif = require "./csv2ldif"
csv2ldif
	ldifConfig: ldif
	inStream: process.stdin
	outStream: process.stdout
	parseOptions: delimiter: ";"