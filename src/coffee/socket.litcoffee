WebSockets API
==============

This API acts as the bridge between the Bacon.js-filled world of
the screens and the raw WebSockets API with which we communicate
with the server.

It is publicised through the *WS* public API.

First, we create the actual WebSocket.

    socket = new WebSocket 'ws://localhost:8080/websocket.rpy'

Transmission
------------

Transmission of data is significantly frustrated by an unfortunate
side-effect of the asynchronous nature of programming on the web -
that is, we cannot guarantee that the socket is actually open yet
when a call is made. Instead, we use a bus to push messages, with
a custom buffering function which will hold all messages until the
socket is ready.

We first create the actual bus. This contains already-encoded data,
which merely needs to be passed to the native WebSockets *send*
API.

    transmitBus = new Bacon.Bus

We also define two auxiliary variables necessary for this to work:
a flag indicating whether the connection has yet been opened, and
a list of callbacks to invoke once it has been opened.

    connected = false
    onConnectCallbacks = []

The buffering function, *bufferTXBus*, implements the protocol
required for *bufferWithTime*. Given its argument, *f*, which decides
when to dispatch the actual message, it:

* Schedules a call at the end of the current iteration of the JavaScript run
  loop if the socket is already connected, and
* Adds it to the list of callbacks to invoked once the socket is open.

    bufferTXBus = (f) ->
        _.defer f if connected
        onConnectCallbacks.push f if not connected

Once the socket is opened, indicated by the *onopen* function in
the WebSocket, we flush the *onConnectCallbacks* queue and set the
*connected* flag, preventing further calls being added to the queue.

    socket.onopen = ->
        connected = true
        do f for f in onConnectCallbacks
        onConnectCallbacks = []

We bind the *transmitBus*, with buffering, to transmit messages
through the native WebSockets API.

    transmitBus.bufferWithTime(bufferTXBus).onValue (x) ->
        socket.send x

Finally, we define the public API function through which clients
can send messages. This function constructs a native JavaScript
object representing the message (without modifying the argument),
then pushes it to the *transmitBus*.

    send = (message, data = {}) ->
        target = _.clone(data)
        target.type = message
        transmitBus.push JSON.stringify(target)

Receipt
-------

Receiving messages through the WebSockets API is an altogether
simpler affair.  We simply define a bus on which messages are
received, and interested clients subscribe to it.

The bus is deliberately publicly exposed as a bus rather than an
event source, so that (for testing and debugging purposes or for
disgusting hacks) clients can *inject* messages to be spread through
the system as if they were received from the server.

    messageBus = new Bacon.Bus
    socket.onmessage = (msg) ->
        messageBus.push msg

Public API
----------

Finally, the public interface to the WebSockets API is presented
through the *WS* global.

    window.WS =
        message: messageBus
        send: send

