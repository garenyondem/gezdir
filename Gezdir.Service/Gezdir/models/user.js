var mongoose = require('mongoose');

var UserSchema = new mongoose.Schema({
    nameSurname: String,
    email: String,
    password: String,
    token: String
}, { versionKey: false });

mongoose.model('User', UserSchema, 'Users');

module.exports = mongoose.model('User');