# Description:
#   lovelivegif.tumblr.comからラブライブgifアニメ出す
#
# Dependencies:
#   "tumblrbot": "0.1.0"
#
# Configuration:
#   HUBOT_TUMBLR_API_KEY - A Tumblr OAuth Consumer Key will work fine
#
# Commands:
#   llgif / lovelivegif - ラブライブgifアニメをランダムで出す


tumblr = require "tumblrbot"
SOURCES = {
  "lovelivegif.tumblr.com"
}

getGif = (blog, msg) ->
  tumblr.photos(blog).random (post) ->
    msg.send post.photos[0].original_size.url

module.exports = (robot) ->
  robot.hear /llgif|lovelivegif/i, (msg) ->
    blog = msg.random Object.keys(SOURCES)
    getGif blog, msg
