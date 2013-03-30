Override Manager
================

This manager defines the display of the *override* container. This is used for
the mode in which raw HTML is sent to be displayed on a screen.

We first set everything in a callback, so that it is invoked only after the
loading of the DOM.

    $ ->

The primary data property contains a string of HTML during override mode, and
null otherwise.

We first use this to set visibility for both the primary and override container
divs.

        Data.overrideText.map((x) -> not x?)
                         .assign $('#container'), 'toggle'
        Data.overrideText.map((x) -> x?)
                         .assign $('#override'), 'toggle'

We also pick up non-null updates to set the HTML content of the override
container.

        Data.overrideText.filter((x) -> x?)
                         .assign $('#override'), 'html'

