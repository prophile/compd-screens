// TODO: synchronise the clock to second boundaries
var Clock = (function() {
    var bus = new Bacon.Bus();
    var sendClockPulse = function() {
        bus.push(new Date());
        setTimeout(sendClockPulse, 1000);
    };
    var stream = bus.toProperty();
    sendClockPulse();
    return stream;
}());

