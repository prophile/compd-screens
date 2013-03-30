Display Selection
=================

The display selector -- as its name probably suggests -- selects what to display
on screen, other than overrides taking priority.

Core Logic
----------

We structure the core logic as a simple series of conditionals.

    selectedDisplay = (state) ->

If the kill mode is active, we display a no entry sign on all displays.

As an exception, judges' displays are not public-facing: on those
we display the origin of the kill.

        return 'no-entry' if state.kill? unless state.mode is 'judge'
        return 'kill-origin' if state.kill? and state.mode is 'judge'

For the judge's display, give the selection from the keyboard.

        return state.judgeSelection if state.mode is 'judge'

For info displays, alternate between the league and timetables based
on the turnover clock - unless an association 3 DS item is active
(which would indicate prizegiving, where we want to minimise
distractions).

        if state.mode is 'info'
            return 'blank' if state.dsAssociation is 3
            return 'day-sched' if state.turnover is 0
            return 'match-sched' if state.turnover is 1
            if state.turnover is 2
                return 'knockout-state' if state.dsAssociation is 2
                return 'league-state'

For zones, we display the zone layout during match time, and blank
during association 3 items, otherwise the default display.

        if state.mode is 'zone'
            return 'zone' if state.dsAssociation in [1, 2]
            return 'blank' if state.dsAssociation is 3
            return 'default'

For layout-mode displays, we display the layout layout during
matches, and blank during association 3 items -- otherwise the arena
welcome sign.

        if state.mode is 'layout'
            return 'layout' if state.dsAssociation in [1, 2]
            return 'blank' if state.dsAssociation is 3
            return 'arena-entrance'

For blank displays, always show blank.

        return 'blank' if state.mode is 'blank'

In all other cases, fall back to the default view.

        return 'default'

Public Property
---------------

First, we define the *data source*, which combines all the streams which the
display selector uses as input.

    dataSource = Bacon.combineTemplate
                     mode: Data.mode,
                     kill: Data.killState
                     judgeSelection: window.JudgeSelection
                     turnover: window.Turnover.map((x) -> x % 3)
                     dsAssociation: window.CurrentDSAssociation

We then use *selectedDisplay* to map the data source, followed by
a final pass to skip duplicates, so that we do not flap display
modes.

    window.SelectedDisplay = dataSource.map(selectedDisplay)
                                       .skipDuplicates()


