'use strict';

var express = require('express'),
    router = express.Router(),
    bodyParser = require('body-parser'),
    async = require('async'),
    _is = require('is_js'),
    error = require('../helpers/error'),
    radian = require('../helpers/radian'),
    constants = require('../resources/constants'),
    authenticate = require('./authenticate'),
    Dictionary = require('../localization/dictionary');

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());

var Event = require('../models/event'),
    Ticket = require('../models/ticket'),
    User = require('../models/user');

router.post('/', authenticate, (req, res) => {
    var isTicket = JSON.parse(req.body.isTicket),
        eventType = req.body.eventType,
        fromDate = req.body.fromDate,
        //untilDate = req.body.untilDate,
        attendeeCount = req.body.attendeeCount,
        coordinates = req.body.coordinates;

    function addConditions(query, callback) {
        // optional conditions
        if (_is.existy(eventType)) {
            query.eventType = eventType;
        }
        if (_is.existy(attendeeCount) && !isTicket) {
            query.attendees = {
                $where: 'attendees.length>'.concat(+attendeeCount)
            }
        }
        if (_is.existy(fromDate) && _is.existy(untilDate)) {
            //query.expirationDate = {
            //    $gte: new Date(untilDate)
            //}
            query.creationDate = {
                $gte: new Date(fromDate)
            }
        }
        //required conditions
        query.location = {
            $geoWithin: {
                $centerSphere: [
                    coordinates,
                    radian(10)
                ]
            }
        }
        process.nextTick(() => {
            callback(null, query);
        });
    }

    var query = {};

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
        (callback) => {
            async.waterfall([
                (cb) => addConditions(query, cb),
                (updatedQuery, cb) => {
                    if (isTicket === true) {
                        Ticket.find(updatedQuery).lean().exec(cb);
                    } else {
                        //event 
                        Event.find(updatedQuery).lean().exec(cb);
                    }
                }
            ], callback);
        }
    ], (err, results) => {
        if (!err) {
            var user = results[0],
                items = results[1],
                dict = Dictionary(user.language);
            async.map(items, (item, callback) => {
                item.eventType = {
                    name: dict.eventTypeName[item.eventType],
                    type: item.eventType
                }
                callback(null, item);
            }, (err, items) => {
                if (!err) {
                    res.status(200).send(items);
                } else {
                    res.status(500).send(error(constants.errorCodes.unableToFindSearchResult));
                }
            });
        } else {
            res.status(500).send(error(constants.errorCodes.unableToFindSearchResult));
        }
    });
});

module.exports = router;