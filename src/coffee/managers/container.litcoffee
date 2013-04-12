Container Manager
=================

This manager defines the visibility of the individual display
containers. It is driven chiefly by the display selector.

Like all managers, it is run on a jQuery callback so that it executes
after the DOM has already been loaded.

    $ ->

We bind the selected display's equivalence to the string 'default'
for the visibility of the default container.

        SelectedDisplay.map( (x) -> x is 'default' )
                       .assign $('#default'), 'toggle'

It is left as an exercise to the reader to guess how the rest of these go...

        SelectedDisplay.map( (x) -> x is 'no-entry' )
                       .assign $('#no-entry'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'kill-origin' )
                       .assign $('#kill-origin'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'match-display' )
                       .assign $('#match-display'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'match-sched' )
                       .assign $('#match-sched'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'league-state' )
                       .assign $('#league-state'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'knockout-state' )
                       .assign $('#knockout-state'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'next-match' )
                       .assign $('#next-match'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'day-sched' )
                       .assign $('#day-sched'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'layout' )
                       .assign $('#layout'), 'toggle'
        SelectedDisplay.map( (x) -> x is 'arena-entrance' )
                       .assign $('#arena-entrance'), 'toggle'
        SelectedDisplay.map( (x) -> /zone-/.test x )
                       .assign $('#zone'), 'toggle'

Selected Zone
-------------

We get the selected zone from the selected display.

        window.SelectedZone =
            SelectedDisplay.map( (x) -> /zone-([0-3])/.exec x )
                           .filter( (x) -> x? )
                           .map( (x) -> parseInt(x[1]) )
                           .toProperty(0)
                           .skipDuplicates()

