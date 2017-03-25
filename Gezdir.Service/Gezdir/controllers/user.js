'use strict';

var express = require('express'),
    router = express.Router(),
    bodyParser = require('body-parser'),
    _is = require('is_js'),
    error = require('../helpers/error'),
    constants = require('../resources/constants');

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());

var User = require('../models/user');

router.post('/login', (req, res) => {
    var query = {
        email: req.body.email,
        password: req.body.password
    }
    var update = {
        language: req.body.language
    }
    var options = {
        new: true,
        fields: {
            _id: 0,
            password: 0
        }
    }
    User.findOneAndUpdate(query, update, options,
        (err, user) => {
            if (!err && _is.existy(user)) {
                res.status(200).send(user);
            } else {
                res.status(500).send(error(constants.errorCodes.unableToFindUser));
            }
        });
});

module.exports = router;