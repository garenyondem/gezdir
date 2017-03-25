'use strict';

var express = require('express'),
    router = express.Router(),
    bodyParser = require('body-parser'),
    _is = require('is_js'),
    error = require('../helpers/error'),
    constants = require('../resources/constants'),
    authenticate = require('./authenticate'),
    async = require('async');

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
        (callback) => User.findOne({ token: req.headers.token }, { _id: 1 }, callback),
        (user, callback) => createEvent(user._id, callback)
    ], (err, event) => {
        if (!err) {
            res.status(200).send(event);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToCreateEvent));
        }
    });
});

// returns nearby events
router.get('/', authenticate, (req, res) => {
    var userLocation = {
        type: 'Point',
        coordinates: [
            req.query.latitude,
            req.query.longtitude
        ]
    }
    function toRadian(kms) {
        return kms / constants.earthRadiusKm;
    }
    var query = {
        expirationDate: {
            $gt: new Date()
        },
        location: {
            $geoWithin: {
                $centerSphere: [
                    userLocation.coordinates,
                    toRadian(1)
                ]
            }
        }
    }
    Event.find(query, (err, events) => {
        if (!err && _is.existy(events) && _is.not.empty(events)) {
            res.status(200).send(events);
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
                attendees: [userId]
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