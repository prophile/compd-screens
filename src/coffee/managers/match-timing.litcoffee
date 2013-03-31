Match Timing Manager
====================

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Input
-----

We require, for displaying match timing, only the current match and
the clock.

        inputStream = Bacon.combineTemplate
            clock: Clock
            currentMatch: CurrentMatch

Display
-------

We pre-select the DOM nodes in which we are interested - all those
with the *next-match-time* class.

        matchTimeNodes = $ '.match-timer'

We bind to our input stream.

        inputStream.onValue (state) ->

There are two cases, which we handle separately - with and without
the existence of a current match.

We first handle the case with the current match.

            if state.currentMatch?
                matchTimeNodes.text FormatTime(state.clock)

We then handle the case without a current match.

            else
                matchTimeNodes.text 'no match'

