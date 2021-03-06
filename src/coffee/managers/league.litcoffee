League Table Manager
====================

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Input
-----

We are interested in two key pieces of input information: the
leaderboard and the team roster.

        inputStream = Bacon.combineTemplate
            teams: Data.teams
            leaderboard: League.leaderboard

Table Management
----------------

We use D3 to set the data within the table.

        inputStream.onValue (state) ->
            nodeHTML = (entry) ->
                "<td>#{entry.position}</td>
                 <td>#{state.teams[entry.team].name}</td>
                 <td>#{entry.score}</td>"

            updateTable = (element, entries) ->
                DisplayInformation "##{element}",
                                   entries,
                                   'tr', nodeHTML

            ENTRIES_PER_SIDE = 14
            updateTable 'league-table-left',
                        state.leaderboard[0...ENTRIES_PER_SIDE]
            updateTable 'league-table-right',
                        state.leaderboard[ENTRIES_PER_SIDE...ENTRIES_PER_SIDE*2]

