from autobahn.websocket import WebSocketServerFactory, \
                               WebSocketServerProtocol, \
                               listenWS
from autobahn.resource import WebSocketResource
import json

class ScreenServerProtocol(WebSocketServerProtocol):
    def onOpen(self):
        self.screen = None

    def do_iam(self, args):
        self.screen = args['screen']
        # Send initial data here

    def onMessage(self, payload, binary):
        plain = json.loads(payload)
        message_type = plain.get('type', 'unknown')
        message_handler = 'do_{0}'.format(message_type)
        getattr(self, message_handler)(plain)

factory = WebSocketServerFactory('wss://localhost:8080', debug = False)
factory.protocol = ScreenServerProtocol

resource = WebSocketResource(factory)

