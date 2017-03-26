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
    Dictionary = require('../localization/dictionary'),
    radian = require('../helpers/radian');

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
            var ticket = result.ticket.toObject(),
                userLanguage = result.userLanguage;
            ticket.eventType = {
                name: Dictionary(userLanguage).eventTypeName[ticket.eventType],
                type: ticket.eventType
            }
            res.status(200).send(ticket);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToCreateTicket));
        }
    });
});

// returns nearby tickets
router.get('/', authenticate, (req, res) => {
    var userLocation = [
        req.query.longitude,
        req.query.latitude
    ];
    var query = {
        expirationDate: {
            $gt: new Date()
        },
        location: {
            $geoWithin: {
                $centerSphere: [
                    userLocation,
                    radian(10)
                ]
            }
        }
    }

    async.parallel([
        (callback) => {
            var query = { token: req.headers.token }
            var projection = { _id: 1, language: 1 }
            User.findOne(query, projection, callback);
        },
        (callback) => Ticket.find(query).lean().exec(callback)
    ], (err, results) => {
        if (!err && _is.existy(results[1])) {
            var user = results[0],
                tickets = results[1],
                dict = Dictionary(user.language);

            async.map(tickets, (ticket, callback) => {
                ticket.eventType = {
                    name: dict.eventTypeName[ticket.eventType],
                    type: ticket.eventType
                }
                var projection = { nameSurname: 1 }
                User.findById(ticket.owner, projection, (err, owner) => {
                    ticket.ownerName = !err ? owner.nameSurname : '';
                    callback(null, ticket);
                });
            }, (err, tickets) => {
                if (!err) {
                    res.status(200).send(tickets);
                } else {
                    res.status(500).send(error(constants.errorCodes.unableToFindTicket));
                }
            });
        } else {
            res.status(500).send(error(constants.errorCodes.unableToFindTicket));
        }
    });
});

// create event from ticket
router.get('/:id/accept', authenticate, (req, res) => {

});

module.exports = router;