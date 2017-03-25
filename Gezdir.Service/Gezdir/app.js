'use strict';

var express = require('express'),
    app = express(),
    db = require('./db/db'),
    UserController = require('./controllers/user'),
    EventController = require('./controllers/event'),
    EventTypeController = require('./controllers/eventType');

app.use('/user', UserController);
app.use('/events', EventController);
app.use('/eventTypes', EventTypeController);

module.exports = app;