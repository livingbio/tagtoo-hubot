/*
HipChat Notification API

send a POST to HipChat via a REST api
*/
require! "node-hipchat"

# initiate the hipchat API client
HipchatClient = new node-hipchat process.env.HUBOT_HIPCHAT_TOKEN

send-hipchat-msg = (msg, room && "RD Team") ->
  # hipchat sending parameters
  msg-options =
    * room: room
      message: msg
      notify: true
      from: "Hubot Notification"
      color: "yellow"


  # send message out
  HipchatClient.postMessage msg-options, (api_res) ->
    console.log api_res

module.exports = (robot) ->
  robot.router.post "/hubot/hipchat_notify", (req, res) ->
    {token, msg, room} = req.body

    # if token doesn't match, return 'denied'
    unless token == process.env.HUBOT_SECRET
      res.end "denied."
    else
      send-hipchat-msg msg, room

      res.end "succeed."
