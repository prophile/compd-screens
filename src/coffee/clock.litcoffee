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

