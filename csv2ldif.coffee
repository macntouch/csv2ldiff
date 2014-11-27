parse = require "csv-parse"
fs = require "fs"
transform = require "stream-transform"
_ = require "underscore"


transformer = (ldifConfig, skipFunction) ->
	firstrow = null
	transformRecordRow = (recordArray) ->
		out = {}
		for key, index in firstrow
			out[key] = recordArray[index]
		out
	
	return transform (record, callback) ->

		unless firstrow?
			firstrow = record
			
			callback null, "\nversion: 1\n\n"
		else
			
			recordObj = transformRecordRow record
			if skipFunction? and skipFunction recordObj
				callback null, ""
			else
				newData = []
				for ldapKey, tableKey of ldifConfig
					value = if _(tableKey).isFunction()
							tableKey recordObj
						else
							recordObj[tableKey]

					unless value is "NULL" or _(value).isEmpty()
						newData.push "#{ldapKey}: #{value}"
				
				callback null, newData.join("\n")+ "\n\n"

		

module.exports = (options) ->
	{ldifConfig, inStream, outStream, parseOptions, skipFunction} = options
	inStream
	.pipe parse parseOptions
	.pipe transformer ldifConfig, skipFunction
	.pipe outStream


