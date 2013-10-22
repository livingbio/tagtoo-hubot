# Description:
#   preview the link content

http = require 'http'

module.exports = (robot) ->
    robot.hear /(^|\s)((https?:\/\/)?[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?)/, (msg) ->
        target_url = escape(msg.match[0])
        http.get { host: target_url }, (res) ->
            data = ''
            res.on 'data', (buffer) ->
                data += buffer
            res.on 'end', () ->
                title = data.match(/<title>(.+?)<\/title>/ig)[0].replace(/<\/?title>/gi, "")
                msg.send "[link] #{title}"
