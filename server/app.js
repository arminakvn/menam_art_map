var Artist, LinksSchema,NodesSchema, ArtistNodes, ArtistNodesSchema, ArtistSchema, Bios, BiosSchema, DateEdgesSchema, DateNodesSchema, LocEdgesSchema, LocNodesSchema, OrgEdgesSchema, OrgNodesSchema, Schema, app, config, express, http, login, mongoOptions, mongoose, options, path, port, uristring;
var express = require('express');
var http = require('http');
var path = require('path');
var async = require('async');
var mongoose = require('mongoose');
var argv = require('optimist').argv;
// var morgan = require('morgan');       // log requests to the console (express4)
// var bodyParser = require('body-parser');  // pull information from HTML POST (express4)
// var methodOverride = require('method-override'); // simulate DELETE and PUT (express4)
// var argv = require('optimist').argv;


var uristring = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://admin:abbas@dbh56.mongolab.com:27567/artistsdb';
var theport = process.env.PORT || 80;
// Makes connection asynchronously.  Mongoose will queue up database
// operations and release them when the connection is complete.
mongoOptions = {
    db: {
      safe: true
    }
  };
mongoose.connect(uristring, function(err, res) {
    if (err) {
    } else {
    }
});
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
    var appDir = process.argv[2] || '../app';
    exports.mongoose = mongoose;
Schema = mongoose.Schema;

  BiosSchema = new Schema({
    _id: Schema.Types.ObjectId,
    name: String,
    Address: String,
    Location: [String],
    Date: [String],
    Organization: String,
    __text: String
  }, {
    collection: 'bios'
  });

  ArtistSchema = new Schema({
    _id: Schema.Types.ObjectId,
    source: String,
    group: Number,
    target: String,
    lat: String,
    long: String
  }, {
    collection: 'artists'
  });

  LinksSchema = new Schema({
    _id: Schema.Types.ObjectId,
    source: Number,
    target: Number,
    value: Number
  }, {
    collection: 'links'
  });

  NodesSchema = new Schema({
    _id: Schema.Types.ObjectId,
    name: String,
    group: Number
  }, {
    collection: 'nodes'
  });


  BiosSchema.methods.findLimited = function(cb) {
    var query;
    query = this.model('Bios').find({});
    query.limit();
    return query.exec(cb);
  };

  ArtistSchema.methods.findLimited = function(cb) {
    var query;
    query = this.model('Artist').find({});
    query.limit();
    return query.exec(cb);
  };

  LinksSchema.methods.findLimited = function(cb) {
    var query;
    query = this.model('Links').find({});
    query.limit();
    return query.exec(cb);
  };

  NodesSchema.methods.findLimited = function(cb) {
    var query;
    query = this.model('Nodes').find({});
    query.limit();
    return query.exec(cb);
  };

  ArtistSchema.methods.findByTarget = function(cb) {
    var query;
    query = this.model('Artist').find({});
    query.where('target', this.target);
    query.limit();
    return query.exec(cb);
  };

  ArtistSchema.methods.findBySource = function(cb) {
    var query;
    query = this.model('Artist').find({});
    query.where('source', this.source);
    query.limit();
    return query.exec(cb);
  };

  ArtistSchema.methods.findByGroup = function(cb) {
    var query;
    query = this.model('Artist').find({});
    query.where('group', this.group);
    query.limit();
    return query.exec(cb);
  };

  ArtistSchema.methods.findSource = function(cb) {
    var query;
    query = this.model('Artist').find({});
    query.distinct('source');
    return query.exec(cb);
  };


  BiosSchema.methods.findByName = function(cb) {
    var query;
    query = this.model('Bios').find({});
    query.where('name', this.name);
    query.limit();
    return query.exec(cb);
  };

  // mongoose.model('Bios', BiosSchema);
  var Bios = mongoose.model( 'Bios', BiosSchema );
  var Artist = mongoose.model( 'Artist', ArtistSchema );
  var Links = mongoose.model( 'Links', LinksSchema );
  var Nodes = mongoose.model( 'Nodes', NodesSchema );
  // mongoose.model('Artist', ArtistSchema);
  // mongoose.model('ArtistNodes', ArtistNodesSchema);

  exports.findAll = function(req, res) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    Artist.find({}, function(err, results) {
      return res.send(results);
    });
  };

  exports.findById = function() {};

  exports.add = function() {};

  exports.update = function() {};

  exports["delete"] = function() {};

  
    var app = express();
    app.configure(function() {
        app.set('port', theport);
        app.set('views', __dirname + appDir);
    });
    app.get('/bios', function(req, res) {
    var bios;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    bios = Bios({});
    bios.findLimited(function(err, bios) {
      return res.json(bios);
    });
  });

  app.get('/biosby/:n', function(req, res) {
    var bios;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    bios = Bios({
      name: req.params.n
    });
    bios.findByName(function(err, bios) {
      return res.json(bios);
    });
  });

  app.get('/artists', function(req, res) {
    var artist;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    artist = Artist({});
    artist.findLimited(function(err, artist) {
      return res.json(artist);
    });
  });

  app.get('/links', function(req, res) {
    var links;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    links = Links({});
    links.findLimited(function(err, links) {
      return res.json(links);
    });
  });

  app.get('/nodes', function(req, res) {
    var nodes;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    nodes = Nodes({});
    nodes.findLimited(function(err, nodes) {
      return res.json(nodes);
    });
  });

  app.get('/artstsby/:t', function(req, res) {
    var artist;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    artist = new Artist({
      target: req.params.t
    });
    artist.findByTarget(function(err, artist) {
      res.json(artist);
    });
  });

  app.get('/artistsbygroup/:g', function(req, res) {
    var artist;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    artist = new Artist({
      group: req.params.g
    });
    artist.findByGroup(function(err, artist) {
      return res.json(artist);
    });
  });

  app.get('/artistsbysource/:source', function(req, res) {
    var artist;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    artist = new Artist({
      source: req.params.source
    });
    artist.findBySource(function(err, artist) {
      return res.json(artist);
    });
  });

  app.get('/artistssource', function(req, res) {
    var artist;
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With');
    artist = Artist({});
    artist.findSource(function(err, artist) {
      return res.json(artist);
    });
  });
    options = {
        dotfiles: 'ignore',
        etag: false,
        extensions: ['htm', 'html'],
        index: false,
        maxAge: '1d',
        redirect: false,
        setHeaders: function(res, path, stat) {
          res.set('x-timestamp', Date.now());
        }
      };

    app.use(function(req, res, next) {
        console.log('%s %s', req.method, req.url);
        next();
    });
    // mount static
    app.use(express.static(path.join(__dirname, appDir)));
    app.use(express.static(path.join(__dirname, '../.tmp')));
    app.use(express.cookieParser());
    app.use(express.bodyParser());
    app.use( app.router );
    app.use( express.methodOverride() );
    app.use( express.errorHandler({ dumpExceptions: true, showStack: true }));

    app.get('/', function(req, res) {
        res.sendfile(path.join(__dirname, appDir + '/index.html'));
    });
    //app.listen(80, argv.fe_ip);
     http.createServer(app).listen(app.get('port'), function() {
         console.log('Express App started!');
     });
});


