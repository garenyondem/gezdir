'use strict';

var express = require('express'),
    app = express(),
    db = require('./db/db'),
    UserController = require('./controllers/user'),
    EventController = require('./controllers/event');

app.use('/user', UserController);
app.use('/events', EventController);

module.exports = app;