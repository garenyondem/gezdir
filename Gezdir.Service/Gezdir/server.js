'use strict';

var port = process.env.PORT || 8810,
    control = require('strong-cluster-control'),
    cluster = require('cluster');


if (cluster.isMaster) {
    control.start({
        size: control.CPUS
    }).on('resize', (size) => {
        console.log('Cluster size: ' + size);
    }).on('startWorker', (worker) => {
        console.log('Worker ' + worker.process.pid + ' is online and starting');
    }).on('error', (err) => {
        console.log('FAILED TO START NEW WORKER!! -> ' + err);
    });
} else {
    require('./child')(port);
}


