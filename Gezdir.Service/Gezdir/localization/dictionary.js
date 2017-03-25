'use strict';

function init(locale) {
    var dictionary = {}
    try {
        dictionary = require('./dictionary.' + locale + '.js');
    } catch (e) {
        dictionary = require('./dictionary.en.js');
    } finally {
        return dictionary;
    }
}

module.exports = init;