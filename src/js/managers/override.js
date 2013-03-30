$(function() {
    Data.overrideText.map(function(x) { return x === null; })
                     .assign($('#container'), 'toggle');
    Data.overrideText.map(function(x) { return x !== null; })
                     .assign($('#override'), 'toggle');
    Data.overrideText.filter(function(x) { return x !== null; })
                     .assign($('#override'), 'html');
});

