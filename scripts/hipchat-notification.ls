/*
HipChat Notification API

send a POST to HipChat via a REST api
*/
require! "node-hipchat"

module.exports = (robot) ->
  robot.router.post "/hubot/hipchat_notify", (req, res) ->
    msg = req.param \msg
    token = req.param \token

    # if token doesn't match, return 'denied'
    unless token == process.env.HUBOT_SECRET
      res.end "access denied."

    # initiate the hipchat API client
    HipchatClient = new node-hipchat process.env.HUBOT_HIPCHAT_TOKEN

    # hipchat sending parameters
    msgOptions =
      * room: req.param \room or "RD Team"
        notify: true
        from: "from API"
        message: msg
        color: "green"

    console.log msgOptions

    # send message out
    HipchatClient.postMessage msgOptions, (api_res) ->
      console.log api_res

    res.end "succeed."




