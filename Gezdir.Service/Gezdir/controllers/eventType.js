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

var EventType = require('../models/eventType'),
    User = require('../models/user');

// returns all event types
router.get('/', (req, res) => {
    function getEventTypes(callback) {
        var projection = { _id: 0 };
        EventType.find({}, projection, callback);
    }

    async.parallel([
        (callback) => User.findOne({ token: req.headers.Token }, { language: 1 }, callback),
        (callback) => getEventTypes(callback)
    ], (err, results) => {
        if (!err && _is.existy(results) && _is.not.empty(results[1])) {
            var userLanguage = results[0].language,
                eventTypes = results[1],
                dict = Dictionary(userLanguage);
            var eventTypes = _(eventTypes).map(function (x) {
                return {
                    name: dict.eventTypeName[x.type],
                    type: x.type
                }
            }).value();

            res.status(200).send(eventTypes);
        } else {
            res.status(500).send(error(constants.errorCodes.unableToGetEventTypes));
        }
    });
});


module.exports = router;