Keyboard Input
==============

We first collect an event stream of all keyboard events sent to the page.

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

We then have a stream of keyboard events coming in based on that
map, discarding those that are not present as well as bounces.

    window.Keyboard = keyboardEvents.map( (k) -> keyMap[k])
                                    .filter( (x) -> x? )
                                    .debounce(150)

