'use strict';

var express = require('express'),
    app = express(),
    db = require('./db/db'),
    UserController = require('./controllers/user'),
    EventController = require('./controllers/event'),
    EventTypeController = require('./controllers/eventType'),
    TicketController = require('./controllers/ticket');

app.use('/user', UserController);
app.use('/events', EventController);
app.use('/eventTypes', EventTypeController);
app.use('/tickets', TicketController);

module.exports = app;