Primary Data Sources
====================

This API presents the primary data sources to the system, from which
all other data are derived.

These primary data sources come in two categories: *local* and *global*.

Items in the *local* category apply *only* to the current screen. Presently,
they are:

* Mode,
* Override HTML.

The former refers to a centrally-controlled option defining what the screen will
be showing, and the latter is a facility for *directly* sending raw HTML to be
displayed.

Items in the *global* category refer to state shared by all screens from compd,
in particular:

* Teams,
* Day schedule,
* Match schedule,
* The *kill* state.

Screen ID Transmission
----------------------

First, we transmit the screen ID to the server, using the *iam* message. In
future, this will be derived from user input in some fashion; for the time
being, it is a constant string, for testing purposes.

    WS.send 'iam', screen: 'example'

Internal Buses
--------------

We create a bus for each of the primary data source, into which we internally
inject events. The public APIs are the *toProperty* equivalents of these.

    mode = new Bacon.Bus
    overrideText = new Bacon.Bus

    teams = new Bacon.Bus
    daySchedule = new Bacon.Bus
    matchSchedule = new Bacon.Bus
    killState = new Bacon.Bus

Message Dispatch
----------------

We subscribe to the message stream from *WS*, handling any data updates which
are relevant to us.

    WS.message.onValue (msg) ->
        switch msg.type

The first case we handle is that of the *mode* message, containing a new mode
for us to enter.

            when "mode" then mode.push msg.mode

The *teams* message contains an updated teams information object, which we
simply republish verbatim.

            when "teams" then teams.push msg.teams

Similarly for the day and match schedules.

            when "day" then daySchedule.push msg.schedule
            when "matches" then matchSchedule.push msg.schedule

For the override text, we are able to do something similar. Note, however, that
the override text, while normally a string, is nullable, with the null value
indicating that this screen should not be overridden.

            when "override" then overrideText.push msg.override

Finally, we handle the *kill* state. The *kill* state is controlled via two
messages rather than one: the *kill* message, indicating that the kill mode has
been triggered and containing the screen ID of the source as its argument, and
the *kill-end* message, indicating that the kill mode has been administratively
cleared.

            when "kill" then killState.push msg.source
            when "kill-end" then killState.push null

Public API
----------

We publish properties for each of the primary data sources, each of which has a
sensible default value.

    window.Data =

The *mode* property contains the initial startup mode, *default*, which shows
the Student Robotics logo as well as a clock.

        mode: mode.toProperty 'default'

The *teams* property contains an empty team mapping.

        teams: teams.toProperty {}

The *daySchedule* and *matchSchedule* properties similarly contain empty
schedules as their initial values.

        daySchedule: daySchedule.toProperty []
        matchSchedule: matchSchedule.toProperty []

The *overrideText* and *killState* properties are nullable, and are both given
null as their initial values.

        overrideText: overrideText.toProperty null
        killState: killState.toProperty null

