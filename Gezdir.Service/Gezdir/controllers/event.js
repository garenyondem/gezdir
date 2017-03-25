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
            creationDate: req.body.creationDate,
            expirationDate: req.body.expirationDate,
            location: {
                type: 'Point',
                coordinates: [
                    req.body.latitude,
                    req.body.longtitude
                ]
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

    var lat = req.query.latitude,
        lon = req.query.longtitude;

    var location = {
        type: 'Point',
        coordinates: [
            lat,
            lon
        ]
    }
    //TODO: 2d search in 1km distance
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

module.exports = router;