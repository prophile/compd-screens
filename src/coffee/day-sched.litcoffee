Day Schedule
============

The day schedule, by and large, is managed within the basic data module. This
only covers tracking the current schedule.

Active Item Algorithm
---------------------

Given the list of items today (sorted), we find which is active at a given time
and return it. If no reference point is specified, we use the current time as
the reference point.

    findActiveDSItem = (list, referencePoint) ->
        referencePoint = (new Date).valueOf() * 0.001 unless referencePoint?
        last = x for x in list when x.start <= referencePoint
        last

Public Property
---------------

We publish the current day schedule item as *CurrentDSItem* - found by sampling
the day schedule by clock pulses, and mapping with the previously defined
*findActiveDSItem* function.

    window.CurrentDSItem = Data.daySchedule
                               .sampledBy(Clock)
                               .map(findActiveDSItem)
                               .skipDuplicates()

We also publish, specifically, the association of the current DS item, with the
value 0 if no current DS item could be established.

    window.CurrentDSAssociation =
        window.CurrentDSItem.map (x) ->
            return x.association if x?
            return 0

