'use strict';

var mongoose = require('mongoose'),
    connectionUri = 'mongodb://karakarga:6urWivlMwFZ6afCBL1Ss@ds139480.mlab.com:39480/hackathondb',
    log = require('../utilities/log'),
    consoleLog = new log.console();

mongoose.connect(connectionUri, (err) => {
    var message = 'DB Connection status: ' + !err;
    if (!err) {
        consoleLog.success(message);
    } else {
        consoleLog.error(message);
    }
});