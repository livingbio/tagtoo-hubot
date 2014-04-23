
module.exports = (robot) ->
  robot.router.post "/hubot/hipchat_notify", (req, res) ->
    msg = req.param \msg
    token = req.param \token

    # if token doesn't match, return 'denied'
    unless token is process.env \HUBOT_SECRET
      res.end "access denied."

    HipchatClient = new (require hipchat) process.env.HUBOT_HIPCHAT_TOKEN

    msgOptions =
      * room: req.param \room or "RD Team"
        notify: true
        from: "from API"
        message: msg
        color: "green"

    console.log msgOptions

    HipchatClient.postMessage msgOptions, (api_res) ->
      console.log api_res
      res.end api_res


