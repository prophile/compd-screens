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

Formatting
----------

Match timing format differs based on four match modes.

We treat them here separately, although publicised through one
function -- *formatMatchTime* -- which takes as its argument the
number of seconds from the scheduled start time to display (generally
this will be *currentTime* - *startTime*) and returns the formatted
string.

        formatMatchTime = (secondsSinceStart) ->

The first match mode is that of the swap time and initial preparation
for the match, where we simply display the string "upcoming".

            return 'upcoming' if secondsSinceStart < -30

The second mode is that for the 30 seconds before the start of the
match, where we display a countdown timer.

            return "#{-secondsSinceStart}s" if secondsSinceStart < 0

The third mode is that of the main sequence of the match, where we
display the time as M:SS. To do this, we exploit the *FormatDoubleDigit*
function from the *clock* module.

            if secondsSinceStart <= 180
                return Math.floor(secondsSinceStart / 60) +
                       ':' +
                       FormatDoubleDigit(secondsSinceStart % 60)

Finally, for the fourth mode we simply display the end time of the match.

            return '3:00'

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
                matchTimeNodes.text formatMatchTime(state.clock.valueOf()*0.001-
                                                    state.currentMatch.start)

We then handle the case without a current match.

            else
                matchTimeNodes.text 'no match'

