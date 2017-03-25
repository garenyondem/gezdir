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
    unableToFindUser: 'unable_to_find_user',
    unableToCreateEvent: 'unable_to_create_event'
}

module.exports = {
    collectionNames: collectionNames,
    errorCodes: errorCodes
}