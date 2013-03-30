Turnover Clock
==============

The turnover clock is used for multi-page displays, to automatically
switch between them with a period of 12 seconds. Speaking of which,
we define that period in a constant (with a value in milliseconds).

    PERIOD = 12 * 1000

We use the *Clock* object as our source, and simply use *throttle*
to rate-limit it to our period. We then map each event to the value
1, and use an accumulator with *scan* to get a monotonically
incrementing counter.

    window.Turnover = Clock.throttle(PERIOD)
                           .map(1)
                           .scan(0, (a, b) -> a + b)

