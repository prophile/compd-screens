Day Schedule Table Manager
==========================

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Input
-----

We are interested in two key nuggets of input information: the full day
schedule, and the current item within it.

        inputStream = Bacon.combineTemplate
            schedule: Data.daySchedule
            current: CurrentDSItem

Table Management
----------------

We use D3 to set the data within the table.


        nodeHTML = (entry) ->
            dateString = FormatTime(FromUNIX(entry.start), false)
            "<td>#{dateString}</td>
             <td>#{entry.displayName}</td>"

        inputStream.onValue (state) ->
            DisplayInformation '#day-sched-table',
                               state.schedule,
                               'tr', nodeHTML,
                               (nodes) ->
                                   nodes.classed 'info', (entry) ->
                                       entry.key == state.current?.key

