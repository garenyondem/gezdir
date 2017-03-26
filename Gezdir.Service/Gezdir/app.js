'use strict';

var express = require('express'),
    app = express(),
    db = require('./db/db'),
    UserController = require('./controllers/user'),
    EventController = require('./controllers/event'),
    EventTypeController = require('./controllers/eventType'),
    TicketController = require('./controllers/ticket'),
    SearchController = require('./controllers/search');

app.use('/user', UserController);
app.use('/events', EventController);
app.use('/eventTypes', EventTypeController);
app.use('/tickets', TicketController);
app.use('/search', SearchController);

module.exports = app;