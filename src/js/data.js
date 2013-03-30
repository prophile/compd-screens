var Data = (function() {
    var screenName = 'example'; // TODO: get this from somewhere!
    WS.send('iam', {'screen': screenName});
    var mode = new Bacon.Bus();
    var teams = new Bacon.Bus();
    var daySchedule = new Bacon.Bus();
    var matchSchedule = new Bacon.Bus();
    var overrideText = new Bacon.Bus();
    var killState = new Bacon.Bus();
    WS.message.onValue(function(msg) {
        // stuff here!
        switch (msg.type) {
            case "mode":
                mode.push(msg.mode);
                break;
            case "teams":
                teams.push(msg.teams);
                break;
            case "day":
                daySchedule.push(msg.schedule);
                break;
            case "matches":
                matchSchedule.push(msg.matches);
                break;
            case "override":
                overrideText.push(msg.override);
                break;
            case "kill":
                killState.push(msg.source);
                break;
            case "kill-end":
                killState.push(null);
                break;
        }
    });
    return {'mode': mode.toProperty('default'),
            'teams': teams.toProperty({}),
            'daySchedule': daySchedule.toProperty([]),
            'matchSchedule': matchSchedule.toProperty([]),
            'overrideText': overrideText.toProperty(null),
            'killState': killState.toProperty(null)};
}());

