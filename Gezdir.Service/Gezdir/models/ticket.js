'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.Types.ObjectId,
    constants = require('../resources/constants');

mongoose.Promise = require('bluebird');

var TicketSchema = new Schema({
    owner: ObjectId,
    creationDate: Date,
    expirationDate: Date,
    location: {
        type: { type: String },
        coordinates: [Number]
    },
    eventType: String,
    quota: Number,
    name: String
}, { versionKey: false });

mongoose.model('Ticket', TicketSchema, constants.collectionNames.Tickets);

module.exports = mongoose.model('Ticket');
