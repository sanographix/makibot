# Description:
#   tiqav から画像を返す
#
# Configuration:
#   HUBOT_TIQAV_404_MESSAGE - 画像がなかった場合のメッセージ
#   HUBOT_TIQAV_ERROR_MESSAGE - エラーが発生した場合のメッセージ
#
# Commands:
#   hubot tiqav <query> - tiqavから <query> で検索した画像を返す。<query> がない場合はランダム。
#
# Author
#   moqada

module.exports = (robot) ->
  robot.respond /tiqav( (.*))?/i, (msg) ->
    query = msg.match[2]
    if query
      imageMe msg, 'http://api.tiqav.com/search.json', {q: query}
    else
      imageMe msg, 'http://api.tiqav.com/search/random.json'

  imageMe = (msg, url, query)->
    http = msg.http url
    if query
      http = http.query query
    http.get() (err, res, body) ->
      if res.statusCode is 404
        msg.send process.env.HUBOT_TIQAV_404_MESSAGE or "画像ない"
      else if res.statusCode isnt 200
        msg.send process.env.HUBOT_TIQAV_ERROR_MESSAGE or "エラーっぽい"
      else
        images = JSON.parse body
        image = msg.random images
        msg.send "http://img.tiqav.com/#{image.id}.#{image.ext}"
