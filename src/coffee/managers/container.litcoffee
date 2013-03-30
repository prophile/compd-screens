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

