# Description:
#   惚れさせ男子データベースからミサワ画像を返す
#
# Configuration:
#   HUBOT_MISAWA_404_MESSAGE - 画像がなかった場合のメッセージ
#   HUBOT_MISAWA_ERROR_MESSAGE - エラーが発生した場合のメッセージ
#
# Commands:
#   hubot misawa <query> - 惚れさせ男子データベースから <query> で検索した画像を返す。<query> がない場合はランダム。
#
# Author
#   moqada

module.exports = (robot) ->
  robot.respond /misawa( (.*))?/i, (msg) ->
    q = msg.match[2]
    msg.http('http://horesase-boys.herokuapp.com/meigens.json')
      .get() (err, res, body) ->
        if err
          res = process.env.HUBOT_MISAWA_ERROR_MESSAGE or "エラーっぽい"
        else
          meigens = JSON.parse body
          if q
            meigens = meigens.filter (meigen) ->
              for key in ['title', 'body', 'character']
                if meigen[key] and meigen[key].indexOf(q) isnt -1
                  return true
              return false
          if meigens.length > 0
            res = msg.random(meigens).image
          else
            res = process.env.HUBOT_MISAWA_404_MESSAGE or "画像ない"
        msg.send res
