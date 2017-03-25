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

var Ticket = require('../models/ticket'),
    User = require('../models/user');

// creates new ticket
router.post('/', authenticate, (req, res) => {
    function createTicket(userId, callback) {
        Ticket.create({
            owner: userId,
            creationDate: new Date(req.body.creationDate),
            expirationDate: new Date(req.body.expirationDate),
            location: {
                type: 'Point',
                coordinates: req.body.coordinates
            },
            name: req.body.name,
            quota: +req.body.quota,
            eventType: req.body.eventType
        }, callback);
    }

    async.waterfall([
        (callback) => {
            var query = {
                token: req.headers.token
            }
            var projection = {
                _id: 1,
                language: 1
            }
            User.findOne(query, projection, callback);
        },
        (user, callback) => {
            createTicket(user._id, (err, ticket) => {
                callback(err, {
                    ticket: ticket,
                    userLanguage: user.language
                });
            });
        }
    ], (err, result) => {
        if (!err) {
            var ticket = results.ticket.toObject(),
                userLanguage = result.userLanguage;
            ticket.eventType = {
                name: Dictionary(userLanguage).eventTypeName[event.eventType],
                type: event.eventType
            }
            res.status(200).send(ticket);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToCreateTicket));
        }
    });
});

// returns nearby tickets
router.get('/', authenticate, (req, res) => {
});

// create event from ticket
router.get('/:id/accept', authenticate, (req, res) => {
});

module.exports = router;