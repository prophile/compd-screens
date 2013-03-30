Clock Source
============

This clock source acts as a synchronisation point for anything which depends
on the time.

First, we create the Bacon.js bus. This event source is the destination to
which we push each clock pulse.

    bus = new Bacon.Bus

The *sendClockPulse* function actually injects the clock pulse into
the bus. It has two functions: not only does it get the current
date and inject it into the bus, but it also schedules itself to
be re-run in one second's time.

    sendClockPulse = ->
        bus.push new Date
        setTimeout sendClockPulse, 1000

We immediately start the clock.

    do sendClockPulse

In the future, it would be a wise plan to try to synchronise the
clock pulses, as close as possible, to the actual tick of the system
RTC. This would mean that, assuming the screens are synchronised
over NTP, they all pulse at the same time.

Finally, we create the public API to the system: a property,
initialised with the current date.

    window.Clock = bus.toProperty new Date

Day Base
--------

The *day base* is the UNIX timestamp of midnight, today. It can be accessed via
the *DayBase* function.

In its implementation, we first get the current time as a JavaScript *Date*
object.

    window.DayBase = ->
        rightNow = new Date

We then, since the *Date* object is mutable, set its time fields to zero.

        rightNow.setHours 0
        rightNow.setMinutes 0
        rightNow.setSeconds 0
        rightNow.setMilliseconds 0

Finally, we convert to a UNIX timestamp, and divide by 1000 since the JavaScript
API is generally oriented around milliseconds rather than seconds.

        rightNow.valueOf() / 1000

As a utility function, we also provide *FromUNIX*, which converts between UNIX
timestamps and JavaScript *Date* objects.

Its implementation is trivial.

    window.FromUNIX = (unixTimestamp) -> new Date(1000 * unixTimestamp)

Time Formatting
---------------

Time must be consistently formatted in the output. We display the
time with a 24-hour clock.

Time is formatted by calling the *formatTime* function, which takes
a JavaScript *Date* object as the argument.

Before defining *FormatTime*, we first define *formatDoubleDigit*,
which takes as its first argument an integer in the range 0 -- 99
inclusive, and returns a two character wide string representing it,
with a given *padding* character for left-padding given in the
second argument, which defaults to '0'.

    formatDoubleDigit = (value, padding = '0') ->
        if value < 10
            "#{padding}#{value}"
        else
            "#{value}"

We now define *FormatTime* utilising *formatDoubleDigit*.

    window.FormatTime = (date, seconds = true) ->
        major = formatDoubleDigit(date.getHours()) +
                ':' +
                formatDoubleDigit(date.getMinutes())
        if seconds
            major +
            ':' +
            formatDoubleDigit(date.getSeconds())
        else
            major

