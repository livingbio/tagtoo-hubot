# Description:
#   preview the link content

request = require 'request'
cheerio = require 'cheerio'
readability = require 'node-readability'

module.exports = (robot) ->
    robot.hear /(^|\s)((https?:\/\/)?([\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?))/gi, (msg) ->
        target_url = msg.match[0]
        #target_url = target_url.replace /^https?:\/\//, ""
        #target_url = target_url.replace /\/$/, ""
        console.log target_url
        request { uri: target_url, method: 'GET' }, (error, res, body) ->
            if not error and res.statusCode == 200
                readability.read body, (err, article) ->
                    title = article.getTitle()
                    $ = cheerio.load(article.getContent())
                    imgs = $ 'img'

                    if imgs.length > 0 
                        img = imgs[0]
                    else
                        $ = cheerio.load(body)
                        imgs = $ 'img'
                        if imgs.length > 0
                            img = imgs[0]
                    msg.send "[Link] #{title}"
                    msg.send img.attribs.src


