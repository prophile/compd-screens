Match Schedule Table Manager
============================

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Input
-----

We are interested in three key nuggets of input information: the full match
schedule, the current item within it, and the teams.

        inputStream = Bacon.combineTemplate
            schedule: Data.matchSchedule
            current: CurrentMatch
            teams: Data.teams

Table Management
----------------

We use D3 to set the data within the table.



        inputStream.onValue (state) ->
            nodeHTML = (entry) ->
                dateString = FormatTime(FromUNIX(entry.start), false)
                if entry.teams?
                  teams = _.map(entry.teams,
                                (x) -> "<td>#{state.teams[x]?.name ? x}</td>")
                           .join('')
                else
                  teams = '<td></td><td></td><td></td><td></td>'
                "<td>#{dateString}</td>
                 #{teams}"
            DisplayInformation '#match-sched-table',
                               state.schedule,
                               'tr', nodeHTML

