Kill Origin Manager
===================

This manager controls the display of the kill origin in the
*kill-origin* layout.

We first set everything in a callback, so that it is loaded only
after the loading of the DOM.

    $ ->

We then simply bind to the kill origin property (when non-null).

        Data.killState.filter( (x) -> x? )
                      .assign $('#kill-location'), 'text'

