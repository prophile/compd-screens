var WS = (function() {
    var Socket = new WebSocket('ws://localhost:8080/websocket.rpy')
    Socket.onerror = function() {
        window.reload();
    };
    var messageBus = new Bacon.Bus();
    var send = function(message, data) {
        data = data || {};
        var target = _.clone(data);
        target.type = message;
        Socket.send(JSON.stringify(target));
    };
    Socket.onmessage = function(msg) {
        messageBus.push(msg);
    };
    return {'message': messageBus,
            'send': send};
}());

