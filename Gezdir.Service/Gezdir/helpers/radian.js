'use strict';

var constants = require('../resources/constants');

function toRadian(kms) {
    return kms / constants.earthRadiusKm;
}

module.exports = toRadian;