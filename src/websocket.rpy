from twisted.internet import defer, reactor
from twisted.application import internet
from autobahn.websocket import WebSocketServerFactory, \
                               WebSocketServerProtocol, \
                               listenWS
from autobahn.resource import WebSocketResource
import json
from copy import copy
import txredisapi as redis

class ScreenServerProtocol(WebSocketServerProtocol):
    @defer.inlineCallbacks
    def redisConnection(self):
        if self.redis is None:
            self.redis = yield self.deferredConnection
        defer.returnValue(self.redis)

    def onConnect(self, connectionRequest):
        self.peer = connectionRequest.peer
        self.redis = None
        return WebSocketServerProtocol.onConnect(self, connectionRequest)

    def onOpen(self):
        self.screen = None
        self.openRedis()

    def openRedis(self):
        self.deferredConnection = redis.Connection(host = '127.0.0.1',
                                                   port = 10056)
        subFactory = redis.SubscriberFactory()
        screen = self
        class ScreenRedisPubSubListenerProtocol(redis.SubscriberProtocol):
            def connectionMade(self):
                redis.RedisProtocol.connectionMade(self)
                self.subscribe(['screen:update'])
                print 'subscribed'

            def messageReceived(self, pattern, channel, message):
                print 'Received: {0}'.format(channel)
                if channel == 'screen:update':
                    screen.sendMode()
        subFactory.protocol = ScreenRedisPubSubListenerProtocol
        reactor.connectTCP('127.0.0.1', 10056, subFactory)
        print 'starting sub connection'

    @defer.inlineCallbacks
    def setScreen(self):
        if self.screen is not None:
            redis = yield self.redisConnection()
            key = 'screen:{0}:host'.format(self.screen)
            yield redis.setex(key, 600, '{0.host} {0.port}'.format(self.peer))

    @defer.inlineCallbacks
    def sendMode(self):
        if self.screen is None:
            return
        redis = yield self.redisConnection()
        key = 'screen:{0}:mode'.format(self.screen)
        currentMode = yield redis.get(key)
        if currentMode is not None:
            self.tx('mode', {'mode': currentMode})
        else:
            # set default
            redis.set(key, 'default')
            self.tx('mode', {'mode': 'default'})

    def onPing(self):
        WebSocketServerProtocol.onPing(self)
        self.setScreen()

    @defer.inlineCallbacks
    def do_iam(self, args):
        self.screen = args['screen']
        self.setScreen()
        # Send initial data here
        self.sendMode()
        self.tx('ack')
        redis = yield self.redisConnection()
        yield redis.publish('screen:connect', self.screen)

    def tx(self, message, data = {}):
        newData = copy(data)
        newData['type'] = message
        print 'SEND: {0}'.format(message)
        jsonCode = json.dumps(newData)
        if len(jsonCode) < 50:
            print 'RAW: {0}'.format(jsonCode)
        self.sendMessage(jsonCode)

    def onMessage(self, payload, binary):
        plain = json.loads(payload)
        message_type = plain.get('type', 'unknown')
        message_handler = 'do_{0}'.format(message_type)
        getattr(self, message_handler)(plain)

factory = WebSocketServerFactory('wss://localhost:8080',
                                 debug = False)
factory.protocol = ScreenServerProtocol

resource = WebSocketResource(factory)

