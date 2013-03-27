###*
 * Module dependencies.
###

express = require 'express'
http = require 'http'
path = require 'path'
io = require 'socket.io'
message = require './models/message'
 
app = express()
server = http.createServer app
io = io.listen server

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join __dirname, "public"
 
app.configure 'development', ->
  app.use express.errorHandler()
 
server.listen app.get 'port'

io.sockets.on 'connection', (socket) ->

  socket.on 'session:start', (data) ->
    conditions = getSphereConditions data
    message.find conditions, (err, messages) ->
      throw err if err
      socket.emit 'messeges:show', { messages: messages}

  socket.on 'message:send', (data) ->
    msg = new message()
    msg.text = data.text
    msg.location = [data.longitude, data.latitude]

    msg.save (err) ->
      throw err if err
      io.sockets.emit 'message:receive', { message: msg }

getSphereConditions = (data) ->
  conditions = 
    location : 
      $within : 
        $centerSphere : 
          [[data.longitude, data.latitude], 0.00015]