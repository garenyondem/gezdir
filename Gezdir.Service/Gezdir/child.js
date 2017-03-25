'use strict';

function init(port) {
    var app = require('./app'),
        log = require('./utilities/log'),
        consoleLog = new log.console();

    app.listen(port, () => {
        consoleLog.success('Server listening on port ' + port);
    });
}
module.exports = init;