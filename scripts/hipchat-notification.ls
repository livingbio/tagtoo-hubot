/*
HipChat Notification Script
- send a POST to HipChat via a REST api
*/
require! "node-hipchat"
require! winston

hubot-name = "塔圖 機器人"

# initiate the hipchat API client
HipchatClient = new node-hipchat process.env.HUBOT_HIPCHAT_NOTIFY_TOKEN
winston.info "Hubot Hipchat client loaded." if HipchatClient

# send hipchat notification
send-hipchat-msg = (msg, room="RD Team", color="green") ->
  # hipchat sending parameters
  msg-options =
    * room: room
      message: msg
      notify: true
      from: hubot-name # notice: this has a length limitation
      color: color

  # send message out
  HipchatClient.postMessage msg-options, (data) ->
    winston.info data


module.exports = (robot) ->
  robot.router.post "/hubot/hipchat_notify", (req, res) ->
    {token, msg, room, color} = req.body

    # if token doesn't match, return 'denied'
    unless token == process.env.HUBOT_SECRET
      res.end "denied."
    else
      send-hipchat-msg msg, room, color
      res.end "succeed."
