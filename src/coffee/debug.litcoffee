Debug Routines
==============

Occasionally, software has bugs. It's also often quite convenient
to be able to fix those bugs.

    window.DEBUG = {}

Debug Data Collections
----------------------

This is a collection of debug data, for great debugging, and debug.

    window.DEBUG.loadDebugData = ->
        dateBase = do DayBase
        WS.message.push
            type: 'mode'
            mode: 'judge'
        WS.message.push
            type: 'override'
            override: null
        WS.message.push
            type: 'teams'
            teams:
                aaa:
                    college: 'College A'
                    name: 'Team A'
                    notes: 'Bees'
                    present: yes
                bbb:
                    college: 'College B'
                    name: 'Team B'
                    notes: ''
                    present: yes
                ccc:
                    college: 'College C'
                    name: 'Team C Alpha'
                    notes: ''
                    present: no
                ccc2:
                    college: 'College C'
                    name: 'Team C Beta'
                    notes: ''
                    present: yes
                ddd:
                    college: 'College D'
                    name: 'Team D'
                    notes: 'eyes'
                    present: yes
        WS.message.push
            type: 'day'
            schedule: [
                {key: 'w', start: dateBase + 3600*9, displayName: 'Doors Open', association: 0}
                {key: 'x', start: dateBase + 3600*9 + 1800, displayName: 'Tinker Time', association: 0}
                {key: 'y', start: dateBase + 3600*11, displayName: 'Briefing', association: 3}
                {key: 'z', start: dateBase + 3600*12, displayName: 'League', association: 1}
            ]

