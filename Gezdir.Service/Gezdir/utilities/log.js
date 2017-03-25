var chalk = require('chalk'),
    error = chalk.bold.red,
    success = chalk.bold.green,
    info = chalk.bold.yellow;

function myConsole() {
    this.error = (message) => {
        console.log(error(message));
    }
    this.success = (message) => {
        console.log(success(message));
    }
    this.info = (message) => {
        console.log(info(message));
    }
}

module.exports = {
    console: myConsole
}