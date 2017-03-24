'use strict';

var express = require('express'),
    router = express.Router(),
    bodyParser = require('body-parser'),
    _is = require('is_js');

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json());

var User = require('../models/user');

function init(req, res, next) {
    var token = req.headers.token;
    if (_is.not.existy(token)) {
        return res.status(500).send('Token expected');
    }
    User.count({ token: token },
        (err, count) => {
            if (count && count > 0) {
                next();
            } else {
                res.status(500).send('Unable to authenticate');
            }
        }
    );
}

module.exports = init;