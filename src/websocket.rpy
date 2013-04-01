from twisted.internet import defer, reactor
from twisted.application import internet
from autobahn.websocket import WebSocketServerFactory, \
                               WebSocketServerProtocol, \
                               listenWS
from autobahn.resource import WebSocketResource
import json
from copy import copy
import txredisapi as redis
import datetime
import time
import re

def dateBase():
    now = datetime.datetime.today()
    epoch = datetime.datetime(now.year,
                              now.month,
                              now.day)
    return time.mktime(epoch.timetuple())

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
                self.subscribe(['screen:update',
                                'comp:schedule',
                                'team:update'])

            def messageReceived(self, pattern, channel, message):
                print 'Received: {0}'.format(channel)
                if channel == 'screen:update':
                    screen.sendMode()
                elif channel == 'comp:schedule':
                    screen.sendDaySchedule()
                elif channel == 'team:update':
                    screen.sendTeamRoster()
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
        overrideKey = 'screen:{0}:override'.format(self.screen)
        overrideStatus = yield redis.get(overrideKey)
        self.tx('override', {'override': overrideStatus})

    @defer.inlineCallbacks
    def sendDaySchedule(self):
        redis = yield self.redisConnection()
        itemCount = yield redis.zcard('comp:schedule')
        allItems = yield redis.zrange('comp:schedule', 0, itemCount,
                                      withscores = True)
        schedule = []
        timeBase = dateBase()
        DisplayNames = {'league': 'League Matches',
                        'knockout': 'Knockout Matches',
                        'lunch': 'Lunch',
                        'open': 'Doors Open',
                        'tinker': 'Tinker Time',
                        'photo': 'Photos',
                        'prizes': 'Awards Ceremony',
                        'briefing': 'Briefing'}
        Associations = {'league': 1,
                        'knockout': 2,
                        'lunch': 0,
                        'open': 0,
                        'tinker': 0,
                        'photo': 0,
                        'prizes': 3,
                        'briefing': 3}
        for key, time in allItems:
            eventType = yield redis.get('comp:events:{0}'.format(key))
            schedule.append({'start': timeBase + time,
                             'displayName': DisplayNames[eventType],
                             'association': Associations[eventType],
                             'key': key})
        self.tx('day', {'schedule': schedule})

    @defer.inlineCallbacks
    def sendTeamRoster(self):
        redis = yield self.redisConnection()
        teams = yield redis.keys('team:*:college')
        teamDB = {}
        for team in teams:
            tla = re.match('team:([a-zA-Z0-9]+):college', team).group(1)
            college = yield redis.get('team:{0}:college'.format(tla))
            name = yield redis.get('team:{0}:name'.format(tla))
            present = yield redis.get('team:{0}:present'.format(tla))
            notes = yield redis.get('team:{0}:notes'.format(tla))
            teamDB[tla] = {'college': college,
                           'name': name,
                           'present': present == 'yes',
                           'notes': notes}
        self.tx('teams', {'teams': teamDB})

    def onPing(self):
        WebSocketServerProtocol.onPing(self)
        self.setScreen()

    @defer.inlineCallbacks
    def do_iam(self, args):
        self.screen = args['screen']
        self.setScreen()
        # Send initial data here
        self.sendMode()
        self.sendDaySchedule()
        self.sendTeamRoster()
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

