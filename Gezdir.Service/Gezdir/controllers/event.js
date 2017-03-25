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

var Event = require('../models/event'),
    User = require('../models/user');

// creates new event
router.post('/', authenticate, (req, res) => {
    var projection = {
        _id: 0
    }
    function createEvent(userId, callback) {
        Event.create({
            guide: userId,
            attendees: [],
            creationDate: new Date(req.body.creationDate),
            expirationDate: new Date(req.body.expirationDate),
            location: {
                type: 'Point',
                coordinates: req.body.coordinates
            },
            eventType: req.body.eventType,
            quota: +req.body.quota,
            groupType: req.body.groupType,
            name: req.body.name
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
            User.findOne(query, projection, callback)
        },
        (user, callback) => {
            createEvent(user._id, (err, event) => {
                callback(err, {
                    event: event,
                    userLanguage: user.language
                });
            })
        }
    ], (err, result) => {
        if (!err) {
            var event = result.event.toObject(),
                userLanguage = result.userLanguage;

            event.eventType = {
                name: Dictionary(userLanguage).eventTypeName[event.eventType],
                type: event.eventType
            }
            res.status(200).send(event);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToCreateEvent));
        }
    });
});

// returns nearby events
router.get('/', authenticate, (req, res) => {
    var groupType = req.query.groupType,
        userLocation = [
            req.query.longitude,
            req.query.latitude
        ];
    function toRadian(kms) {
        return kms / constants.earthRadiusKm;
    }
    var query = {
        groupType: groupType,
        expirationDate: {
            $gt: new Date()
        },
        location: {
            $geoWithin: {
                $centerSphere: [
                    userLocation,
                    toRadian(1)
                ]
            }
        }
    }

    async.parallel([
        (callback) => {
            var query = {
                token: req.headers.token
            }
            var projection = {
                _id: 1,
                language: 1
            }
            User.findOne(query, projection, callback)
        },
        (callback) => Event.find(query).lean().exec(callback)
    ], (err, results) => {
        if (!err && _is.existy(results[1])) {
            var user = results[0],
                events = results[1],
                dict = Dictionary(user.language);

            async.map(events, (event, callback) => {
                event.eventType = {
                    name: dict.eventTypeName[event.eventType],
                    type: event.eventType
                }
                var eventAttendeesStr = _(event.attendees).map(x => x.toString()).value();
                event.attending = !!~eventAttendeesStr.indexOf(user._id.toString());
                var projection = {
                    nameSurname: 1
                }
                User.findById(event.guide, projection, (err, guide) => {
                    event.guideName = !err ? guide.nameSurname : '';
                    callback(null, event);
                });
            }, (err, events) => {
                if (!err) {
                    res.status(200).send(events);
                } else {
                    res.status(500).send(error(constants.errorCodes.unableToFindEvent));
                }
            });
        } else {
            res.status(500).send(error(constants.errorCodes.unableToFindEvent));
        }
    });
});

// returns event by given id
router.get('/:id', authenticate, (req, res) => {
    Event.findById(req.params.id, (err, event) => {
        if (!err && _is.existy(event)) {
            res.status(200).send(event);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToFindEvent));
        }
    });
});

// add user to event
router.put('/:id', authenticate, (req, res) => {
    var eventId = req.params.id;

    function addUserToEvent(userId, callback) {
        //TODO: add quota control
        var update = {
            $addToSet: {
                attendees: userId
            }
        }
        var options = { new: true }
        Event.findByIdAndUpdate(eventId, update, options, callback);
    }

    async.waterfall([
        (callback) => User.findOne({ token: req.headers.token }, { _id: 1 }, callback),
        (user, callback) => addUserToEvent(user._id, callback)
    ], function (err, event) {
        if (!err && _is.existy(event)) {
            res.status(200).send(event);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToAddAttendee));
        }
    });
});

module.exports = router;