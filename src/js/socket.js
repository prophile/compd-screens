var WS = (function() {
    var Socket = new WebSocket('ws://localhost:8080/websocket.rpy')
    Socket.onerror = function() {
        window.reload();
    };
    var messageBus = new Bacon.Bus();
    var transmitBus = new Bacon.Bus();
    var connected = false;
    var onConnectCallbacks = [];
    var send = function(message, data) {
        data = data || {};
        var target = _.clone(data);
        target.type = message;
        transmitBus.push(JSON.stringify(target));
    };
    var bufferTXBus = function(f) {
        if (connected) {
            _.defer(f);
        } else {
            onConnectCallbacks.push(f);
        }
    };
    Socket.onopen = function() {
        connected = true;
        _.forEach(onConnectCallbacks, function(f) {
            _.defer(f);
        });
        onConnectCallbacks = [];
    };
    Socket.onmessage = function(msg) {
        messageBus.push(msg);
    };
    transmitBus.bufferWithTime(bufferTXBus).onValue(function(x) {
        WS.send(x);
    });
    return {'message': messageBus,
            'send': send};
}());

