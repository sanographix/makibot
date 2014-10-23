# Description:
#   LGTM
#
# Commands:
#   LGTM - LGTM画像をランダムで出す

util = require 'util'

module.exports = (robot) ->
  robot.hear /lgtm(?:\s*)$/i, (msg) ->
    msg.http('http://www.lgtm.in/g')
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send util.inspect err
        else
          try
            data = JSON.parse(body)
            msg.send data.actualImageUrl
          catch _err
           msg.send "Ran into an error parsing JSON :("
