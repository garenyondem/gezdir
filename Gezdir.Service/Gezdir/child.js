'use strict';

function init(port) {
    var app = require('./app');
    var server = app.listen(port, () => {
        console.log('Server listening on port ' + port);
    });
}
module.exports = init;