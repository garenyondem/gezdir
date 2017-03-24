'use strict';

var express = require('express'),
    app = express(),
    db = require('./db/db'),
    UserController = require('./controllers/user');

app.use('/user', UserController);

module.exports = app;