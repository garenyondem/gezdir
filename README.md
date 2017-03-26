<p align="center">
  <img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/gezdir_logo.fw.png" height="100">
</p>

Gezdir is a crowd-powered entertainment platform where people come together to discover new places, share experiences and know each other.
You can find enjoyable events or create your own to show your hospitality. You can even search for a friend to carry you along foreign places.

--------------------

# Features

  - Find and join events close to your location
  - Host your own events
  - Be the guide for event requests from exciting people

### Tech

Gezdir uses a number of open source projects to work properly:

* [Node.js](https://nodejs.org/) - evented I/O for the javascript
* [Swift](https://swift.org/) - general purpose programming language
* [MongoDB](https://www.mongodb.com/scale/database-software-open-source) - open source NoSql database engine
* [Express](https://expressjs.com/) - web application framework
* [Async](https://caolan.github.io/async/) - async utilities for node.js
* [Lodash](https://lodash.com/) - js utility lib. for performance
* [is_js](http://is.js.org/) - micro check library
* [Mongoose](http://mongoosejs.com/) - object modeling tool for node.js
* [Strongloop Cluster](https://www.npmjs.com/package/strong-cluster-control) - cluster control for node.js
* [Chalk](https://www.npmjs.com/package/chalk) - terminal string styling
* [CocoaPods](https://cocoapods.org) - dependency manager for swift
* [Spring](https://github.com/MengTo/Spring) - animation library for swift

### Installation
##### Service
[![Run in Postman](https://run.pstmn.io/button.svg)](https://www.getpostman.com/collections/2c263d75ea89570f5371)

Gezdir requires [Node.js](https://nodejs.org/en/download/) v6+ to run.
Open the command prompt at root directory and install the dependencies then start the server. 
```
$ npm i
$ node server
```
or
```
$ npm i
$ npm start
```
App's default port is 8810.
You can demo this service live on [Heroku](https://dashboard.heroku.com). Just keep in mind that free tier of Heroku containers go to sleep after a while of inactivity. First API call will wake it up.

##### IOS
Localization: App is capable of showing both server and client side error messages in two languages (Turkish, English)
Forward Geocoding: Using MKLocalSearch class

<img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios.png" width="250"/><img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios1.png" width="250"/><img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios2.png" width="250"/><img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios3.png" width="250"/><img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios4.png" width="250"/><img src="https://raw.githubusercontent.com/wiki/garenyondem/gezdir/ios5.png" width="250"/>
