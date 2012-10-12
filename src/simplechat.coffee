{Adapter,TextMessage,Robot} = require 'hubot'
SocketIO = require 'socket.io-client'

class SimpleChat extends Adapter
  send: (user, strings...) ->
    strings = strings.map (s) -> "#{user} #{s}"
    @socket.emit('sendMessage', { room: @room, message: str }) for str in strings

  reply: (user, strings...) ->
    @send user, strings...

  run: ->
    self = @
    @socket = SocketIO.connect('http://localhost:3000');
    @room = 'tenforward';
    @socket.emit('join', { room: @room, user: 'hubot' });
    @socket.on 'messaged', (data) =>
      message = "hubot " + data.message;
      self.receive new TextMessage data.user, message
    self.emit 'connected'

exports.use = (robot) ->
  new SimpleChat robot
