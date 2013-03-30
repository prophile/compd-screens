from autobahn.websocket import WebSocketServerFactory, \
                               WebSocketServerProtocol, \
                               listenWS
from autobahn.resource import WebSocketResource
import json

class ScreenServerProtocol(WebSocketServerProtocol):
    def __init__(self, *args, **kwargs):
        WebSocketServerProtocol.__init__(self, *args, **kwargs)
        self.screen = None

    def do_iam(self, args):
        self.screen = args['screen']
        # Send initial data here

    def onMessage(self, payload, binary):
        plain = json.dumps(payload)
        message_type = plain.get('type', 'unknown')
        message_handler = 'do_{0}'.format(message_type)
        self.getattr(self, message_handler)(plain)

factory = WebSocketServerFactory('wss://localhost:8080', debug = False)
factory.protocol = ScreenServerProtocol

resource = WebSocketResource(factory)

