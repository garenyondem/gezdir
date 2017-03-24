var mongoose = require('mongoose'),
    constants = require('../resources/constants');

var UserSchema = new mongoose.Schema({
    nameSurname: String,
    email: String,
    password: String,
    token: String
}, { versionKey: false });

mongoose.model('User', UserSchema, constants.collectionNames.Users);

module.exports = mongoose.model('User');