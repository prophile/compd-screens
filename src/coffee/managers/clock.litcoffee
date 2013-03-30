Clock Manager
=============

This manager controls the clock display on the *default* layout.

We first set everything in a callback, so that it is invoked only
after the loading of the DOM.

    $ ->

Time Formatting
---------------

Time must be consistently formatted in the output. We display the
time with a 24-hour clock.

Time is formatted by calling the *formatTime* function, which takes
a JavaScript *Date* object as the argument.

Before defining *formatTime*, we first define *formatDoubleDigit*,
which takes as its first argument an integer in the range 0 -- 99
inclusive, and returns a two character wide string representing it,
with a given *padding* character for left-padding given in the
second argument, which defaults to '0'.

        formatDoubleDigit = (value, padding = '0') ->
            if value < 10
                "#{padding}#{value}"
            else
                "#{value}"

We now define *formatTime* utilising *formatDoubleDigit*.

        formatTime = (date) ->
            return formatDoubleDigit(date.getHours()) +
                   ':' +
                   formatDoubleDigit(date.getMinutes()) +
                   ':' +
                   formatDoubleDigit(date.getSeconds())

Clock Pulse Updates
-------------------

We bind to the *Clock* property, which gives the date.

        Clock.map(formatTime)
             .assign $('#clock'), 'text'

