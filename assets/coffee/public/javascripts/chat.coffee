socket = io.connect()

navigator.geolocation.getCurrentPosition (position) ->
  position = 
    latitude: position.coords.latitude
    longitude: position.coords.longitude

  socket.emit 'session:start', position

socket.on 'messeges:show', (data) ->
  for message in data.messages
    $("div#chat-area").prepend "<div>" + message.text + "</div>"
 
socket.on 'message:receive', (data) ->
  $("div#chat-area").prepend "<div>" + data.message.text + "</div>"

$('#send').click (event) ->
#send = ->

  navigator.geolocation.getCurrentPosition (position) ->
    latitude = position.coords.latitude
    longitude = position.coords.longitude

    msg = 
      text: $("input#message").val()
      latitude: latitude 
      longitude: longitude

    $("input#message").val ""
    socket.emit 'message:send', msg
