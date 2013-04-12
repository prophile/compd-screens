Match Schedule
==============

The match schedule, as with the day schedule, is mainly managed within the basic
data module - this module defines only useful utilities.

Constants
---------

We define two constants within this module -- *MATCH_PREROLL*, and
*MATCH_LENGTH*.

*MATCH_PREROLL* is the amount of time, in seconds, before the start
time of a match during which it should be considered active. Its
current value is 180 seconds, which is 30 seconds of swap time and
60 seconds boot period.

    MATCH_PREROLL = 30 + 60

*MATCH_LENGTH* is simply the length of a match in seconds, including
setup and tear-down time - presently 5 minutes.

    MATCH_LENGTH = 60*5

*MATCH_POSTROLL* is the amount of time, in seconds, between the
start time of a match and when it is considered to have ended. It
is defined in terms of *MATCH_PREROLL* and *MATCH_LENGTH*.

    MATCH_POSTROLL = MATCH_LENGTH - MATCH_PREROLL

Match Tracking
--------------

The *firstMatchAfter* function takes as its argument a match schedule,
and a *reference point*, being a JavaScript *Date* object. It finds
the first match in the schedule whose consideration period begins
at or after the reference point. It may also take an optional
*feasibility condition*, to further filter the matches considered.

    firstMatchAfter = (schedule, referencePoint, feasilibilty) ->

If the feasibility condition is unspecified, we use a default
condition which simply accepts all matches.

        unless feasibility?
            feasibility = (match) -> yes

We convert the reference point into a UNIX timestamp for our use.

        referenceUNIX = referencePoint.valueOf() * 0.001

We then use Underscore's *find* function to find the first satisfying
match.

        _.find schedule, (match) ->
            return no unless feasibility(match, referencePoint)
            match.start - MATCH_PREROLL >= referenceUNIX

Current Match
-------------

We provide the current match (nullable) via the *CurrentMatch*
property. It is a map on the *Data.matchSchedule* property, and the
clock.

First, we define the data source.

    currentMatchSource =
        Bacon.combineTemplate
            schedule: Data.matchSchedule
            clock: Clock

We then define the stream itself, as a map over the input source.

    currentMatch = currentMatchSource.map (data) ->

We find the first match active now, using *firstMatchAfter*. A
feasibility condition is passed to constrain matches to only those
which have not ended.

        firstMatchAfter data.schedule, data.clock, (match, ref) ->
            not (match.start + MAX_POSTROLL > ref)

The public property simply removes the duplicates from that stream.

    window.CurrentMatch = currentMatch.skipDuplicates()

Next Match
----------

We also provide the next match (nullable) via the *NextMatch*
property. It is defined similarly to *CurrentMatch*, except with
the additional feasibility condition of not being the current match.

We first define the data source.

    nextMatchSource =
        Bacon.combineTemplate
            schedule: Data.matchSchedule
            clock: Clock
            currentMatch: CurrentMatch

We then define the stream itself, again as a map over the source.

    nextMatch = nextMatchSource.map (data) ->

As with the current match, we use *firstMatchAfter*, with a feasibility
condition this time specifying that the match is not the current
match.

        firstMatchAfter data.schedule, data.clock, (match) ->
            match.key isnt data.currentMatch?.key

We then publish it by removing duplicates.

    window.NextMatch = nextMatch.skipDuplicates()

