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
    unableToCreateEvent: 'unable_to_create_event',
    unableToFindEvent: 'unable_to_find_event',
    unableToFindEventsNearby: 'unable_to_find_events_nearby',
    unableToGetEventTypes: 'unable_to_get_event_types',
    unableToAddAttendee: 'unable_to_add_attendee'
}

const earthRadiusKm = 6371;

module.exports = {
    collectionNames: collectionNames,
    errorCodes: errorCodes,
    earthRadiusKm: earthRadiusKm
}