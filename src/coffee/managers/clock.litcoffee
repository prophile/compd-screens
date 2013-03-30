Clock Manager
=============

This manager controls the clock display on the *default* layout.

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->


Clock Pulse Updates
-------------------

We bind to the *Clock* property, which gives the date.

        Clock.map(FormatTime)
             .assign $('#clock'), 'text'

