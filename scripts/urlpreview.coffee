# Description:
#   preview the link content

http = require 'http'

module.exports = (robot) ->
    robot.hear /(^|\s)([\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?)/gi, (msg) ->
        target_url = msg.match[0]
        console.log target_url
        http.get { host: target_url }, (res) ->
            data = ''
            res.on 'data', (buffer) ->
                data += buffer
            res.on 'end', () ->
                title = data.match(/<title>(.+?)<\/title>/i)[1]
                msg.send title
                msg.send "[link] #{title}"
