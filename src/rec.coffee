# Description:
#   A hubot script to record chat histories
# 
# Dependencies:
#   moment
#   moment-duration-format
#   ejs
# 
# Configuration:
#   HUBOT_REC_MAX_MESSAGES
#   HUBOT_REC_MAX_DURATION
#
# Commands:
#   hubot rec start <title> - start recording, optionally with title
#   hubot rec cancel - cancel current recording
#   hubot rec stop - stop current recording, and upload recorded messages to a external service (default: anonymous gist)
#   hubot rec title <title> - change the title of current recording
#   hubot rec status - show status (recording or not)
#   hubot rec list - list recordings
#   hubot rec delete <number> - delete recording
#
# Author:
#   tily <tidnlyam@gmail.com>

require 'moment-duration-format'
moment = require 'moment'
ejs = require 'ejs'

rec = {}

formatRec = (rec)->
  # Example: Untitled at 2015/03/16 19:31:00 (room=Shell, duration=00:02:30, messages=1255)
  stoppedAt = rec.stoppedAt || Date.now()
  duration = moment.duration((stoppedAt - rec.startedAt)/1000, 'seconds').format('hh:mm:ss', trim: false)
  startedAt = moment(rec.startedAt).format('YYYY/MM/DD hh:mm:ss')
  formatted = rec.title + ' at ' + startedAt
  formatted + ' (room=' + rec.room + ', duration=' + duration + ', messages=' + rec.messages.length + ')'

recHear = (msg)->
  room = msg.message.room
  return if !rec[room]

  message = msg.message
  message.createdAt = Date.now()
  rec[room].messages.push(message)

recStart = (msg)->
  room = msg.message.room
  return msg.reply "Error: already recording: " + formatRec(rec[room]) if rec[room]

  rec[room] = 
    room: room
    title: msg.match[2] || 'Untitled'
    startedAt: Date.now()
    messages: []
  msg.send "started recording: " + formatRec(rec[room])

recCancel = (msg)->
  room = msg.message.room
  return msg.reply "Error: not yet recording" if !rec[room]

  msg.reply "cancelled recording: " + formatRec(rec[room])
  rec[room] = null

recStop = (msg)->
  room = msg.message.room
  return msg.reply "Error: not yet recording" if !rec[room]

  rec[room].stoppedAt = Date.now()
  msg.robot.brain.data.rec.push(rec[room])
  msg.robot.brain.save()
  msg.send "stopped recording: " + formatRec(rec[room])
  msg.robot.emit("recStopped", rec: rec[room], msg: msg)
  rec[room] = null

recTitle = (msg)->
  room = msg.message.room
  return msg.reply "Error: not yet recording" if !rec[room]
  oldTitle = rec[room].title
  newTitle = msg.match[2]
  rec[room].title = newTitle
  msg.reply "renamed " + oldTitle + " to " + newTitle

recStatus = (msg)->
  room = msg.message.room
  if rec[room]
    msg.reply "now recording: " + formatRec(rec[room])
  else
    msg.reply "not recording"

recList = (msg)->
  if !msg.robot.brain.data.rec
    msg.robot.brain.data.rec = []
  if msg.robot.brain.data.rec.length == 0
    msg.send "(no recordings)"
  else
    for rec, i in msg.robot.brain.data.rec
      msg.send "[" + i + "] " + formatRec(rec)

recDelete = (msg)->
  if !msg.robot.brain.data.rec
    msg.robot.brain.data.rec = []
  idx = parseInt(msg.match[1])
  msg.robot.brain.data.rec.splice(idx, 1)
  msg.robot.brain.save()

module.exports = (robot)->
  if !robot.brain.data.rec
    robot.brain.data.rec = []

  robot.hear /.+/, recHear
  robot.respond /rec start(\s+(.+))?/, recStart
  robot.respond /rec cancel/, recCancel
  robot.respond /rec stop/, recStop
  robot.respond /rec title(\s+(.+))/, recTitle
  robot.respond /rec status/, recStatus
  robot.respond /rec list/, recList
  robot.respond /rec delete (\d+)/, recDelete

  robot.rec =
    start: recStart
    cancel: recCancel
    stop: recStop
    title: recTitle
    status: recStatus
    list: recList
    delete: recDelete
