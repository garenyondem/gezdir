'use strict';

const collectionNames = {
    Users: 'Users',
    UserLocations: 'UserLocations',
    Events: 'Events',
    EventTypes: 'EventTypes'
}

const errorCodes = {
    missingToken: 'missing_token',
    unableToAuthenticate: 'unable_to_authenticate',
    unableToFindUser: 'unable_to_find_user'
}

module.exports = {
    collectionNames: collectionNames,
    errorCodes: errorCodes
}