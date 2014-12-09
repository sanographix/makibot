# Description:
#   Returns weather information from weather.livedoor.com
#
#
# Commands:
#   hubot 天気 <地名> - 天気予報情報を返します
#
# Author:
#   ryurock

parser = require('xml2json')
async = require('async')
require('date-utils')

weathearList = require('../node_modules/hubot-weather-ja/config/weather_area_list.json')

module.exports = (robot) ->
  robot.respond /天気\s*(.*)?$/i, (msg) ->
    place  = '東京'
    place  = msg.match[1] if msg.match[1]?

    async.waterfall([
      (callback) ->
        weathearList.some((v,i) ->
          if v.city instanceof Array
            v.city.some((data, j) ->
              if data.title == place
                callback(null, data)
                return true
            )
          else
            if v.city.title == place
              callback(null, v.city)
              return true
        )
      , (areaData, callback) ->
        # livedoor 天気予報APIのバグ arealistのIDが5桁のものは0パディングしないといけない
        areaId =  ("0" + areaData.id).slice(-6)
        msg
          .http('http://weather.livedoor.com/forecast/webservice/json/v1')
          .query(city : areaId)
          .get() (err, res, body) ->
            json = JSON.parse(body)
            callback(null, json)
    ], (err, result) ->
      throw new Error('err catched.') if err
      forecastTime = new Date(result.publicTime)
      text = "【お天気情報 #{place}】\n" +
      "■  #{forecastTime.toFormat("YYYY年MM月DD日HH24時MI分")}の予報です！\n" +
      "予報 : #{result.forecasts[0].telop}\n" +
      "#{result.description.text}\n" +
      "詳しい情報は下記を参照\n\n" +
      "#{result.link}"

      msg.send text
    )
