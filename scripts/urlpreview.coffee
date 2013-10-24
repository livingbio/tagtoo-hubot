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
        request { uri: target_url, method: 'GET', headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.101 Safari/537.36' } }, (error, res, body) ->
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
                    
                    img_src = img.attribs.src

                    console.log "[DEBUG] #{img_src}"

                    msg.send "[Link] #{title}"

                    if img_src.match(/^\/\//)
                        img_url = "http:#{img_src}"
                    else if img_src.match(/^\./)
                        target_url = target_url.replace /#\w*$/g , ""
                        target_url = target_url.replace /\?\w*$/g , ""
                        img_url = target_url + img_src
                    else if img_src.match(/^\//)
                        img_url = "http://#{res.request.uri.host}#{img_src}"
                    else
                        img_url = img_src
                    
                    if img_url
                        msg.send img_url


