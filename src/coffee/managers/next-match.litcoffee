Next Match Manager
==================

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Input
-----

We need both the next match and the list of teams as our inputs.

        inputStream = Bacon.combineTemplate
            teams: Data.teams
            next: NextMatch

List Management
---------------

We use D3 to set the data within the list.

        inputStream.onValue (state) ->
            return unless state.next?

            nodeHTML = (entry) ->
                "<li>#{state.teams[entry].name}</li>"

            DisplayInformation '.next-match-teams',
                               state.next.teams,
                               'li', nodeHTML

Time Display
------------

We use the next match alone for the display of its start time.

    NextMatch.onValue (match) ->
        if match?
            $('.next-match-time').text(FormatTime(FromUNIX(match.start),
                                                        false))
        else
            $('.next-match-time').text('-')

