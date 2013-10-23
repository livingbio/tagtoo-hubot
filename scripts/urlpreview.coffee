# Description:
#   preview the link content

http = require 'https'
request = require 'request'

module.exports = (robot) ->
    robot.hear /(^|\s)((https?:\/\/)?([\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?))/gi, (msg) ->
        target_url = msg.match[0]
        #target_url = target_url.replace /^https?:\/\//, ""
        #target_url = target_url.replace /\/$/, ""
        console.log target_url
        request { uri: target_url, method: 'GET' }, (error, res, body) ->
            if not error and res.statusCode == 200
                title = body.match(/<title>(.+?)<\/title>/i)[1]
                msg.send "[link] #{title}"
