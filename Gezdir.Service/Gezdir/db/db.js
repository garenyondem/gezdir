'use strict';

var mongoose = require('mongoose');
var connectionUri = 'mongodb://karakarga:6urWivlMwFZ6afCBL1Ss@ds139480.mlab.com:39480/hackathondb';

mongoose.connect(connectionUri, (err) => {
    console.log('DB Connection status: ' + !err);
});