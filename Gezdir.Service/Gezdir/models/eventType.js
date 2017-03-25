'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    constants = require('../resources/constants');

var EventTypeSchema = new Schema({
    type: { type: String }
}, { versionKey: false });

mongoose.model('EventType', EventTypeSchema, constants.collectionNames.EventTypes);

module.exports = mongoose.model('EventType');