'use strict';

var app = require('./app'),
    port = process.env.PORT || 8810;

var server = app.listen(port, () => {
    console.log('Server listening on port ' + port);
});