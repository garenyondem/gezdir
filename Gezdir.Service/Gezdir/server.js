'use strict';

var port = process.env.PORT || 8810,
    control = require('strong-cluster-control'),
    cluster = require('cluster'),
    log = require('./utilities/log'),
    consoleLog = new log.console();


if (cluster.isMaster) {
    control.start({
        size: control.CPUS
    }).on('resize', (size) => {
        consoleLog.info('Cluster size: ' + size);
    }).on('startWorker', (worker) => {
        consoleLog.info('Worker ' + worker.process.pid + ' is online and starting');
    }).on('error', (err) => {
        consoleLog.error('FAILED TO START NEW WORKER!! -> ' + err);
    });
} else {
    require('./child')(port);
}


