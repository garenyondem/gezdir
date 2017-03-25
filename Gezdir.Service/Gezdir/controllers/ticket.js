'use strict';

var express = require('express'),
    router = express.Router(),
    bodyParser = require('body-parser'),
    _is = require('is_js'),
    error = require('../helpers/error'),
    constants = require('../resources/constants'),
    authenticate = require('./authenticate'),
    async = require('async'),
    _ = require('lodash'),
    Dictionary = require('../localization/dictionary');

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());

var Ticket = require('../models/ticket');

// creates new ticket
router.post('/', authenticate, (req, res) => {
});

// returns nearby tickets
router.get('/', authenticate, (req, res) => {
});

// create event from ticket
router.get('/:id/accept', authenticate, (req, res) => {
});

module.exports = router;