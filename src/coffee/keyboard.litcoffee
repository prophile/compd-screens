Keyboard Input
==============

We first collect an event stream of all keyboard events sent to the
page.

    keyboardEvents = $(document).asEventStream('keydown')
                                .map('.keyCode')

We keep a map of keycodes to internal names.

    keyMap =
        48: 'view-0',
        49: 'view-1',
        50: 'view-2',
        51: 'view-3',
        52: 'view-4',
        53: 'view-5',
        54: 'view-6',
        55: 'view-7',
        56: 'view-8',
        57: 'view-9',
        75: 'kill', # k
        82: 'reidentify', # t
        84: 'load-debug', # t

We then have a stream of keyboard events coming in based on that
map, discarding those that are not present as well as bounces.

    window.Keyboard = keyboardEvents.map( (k) -> keyMap[k] )
                                    .filter( (x) -> x? )
                                    .debounce(150)

Judge Selection
---------------

The keys 1-6 are used to select between display on the judge's desk.

We keep a property here to select between them.

    displayMap =
        'view-1': 'match-display'
        'view-2': 'match-sched'
        'view-3': 'league-state'
        'view-4': 'knockout-state'
        'view-5': 'layout'
        'view-6': 'day-sched'
        'view-7': 'zone-0'
        'view-8': 'zone-1'
        'view-9': 'zone-2'
        'view-0': 'zone-3'

    window.JudgeSelection = window.Keyboard.map( (k) -> displayMap[k] )
                                           .filter( (x) -> x? )
                                           .toProperty('match-display')
                                           .skipDuplicates()

Re-identification Triggering
----------------------------

When the 'R' character is pressed, we allow the user to re-enter
the screen's identity.

    Keyboard.filter( (x) -> x is 'reidentify' )
            .onValue ->
                do IdentityPrompt.push

