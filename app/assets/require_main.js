(function() {
  requirejs.config({
    baseUrl: "assets",
    urlArgs: 'bust=' + Math.random(),
    paths: {
      backbone: "./bower_components/backbone-amd/backbone",
      localstorage: "./bower_components/backbone.localstorage/backbone.localstorage",
      jquery: "./bower_components/jquery/jquery",
      underscore: "./bower_components/underscore-amd/underscore",
      marionette: "./bower_components/backbone.marionette/lib/backbone.marionette",
      tpl: "./bower_components/requirejs-tpl/tpl",
      json2: "./bower_components/json2/json2",
      d3: "./bower_components/d3/d3",
      polyhedron: "./bower_components/d3-plugins/geo/polyhedron/polyhedron",
      topojson: "./bower_components/topojson/topojson"
    },
    shim: {
      underscore: {
        exports: "_"
      },
      backbone: {
        deps: ["jquery", "underscore", "json2"],
        exports: "Backbone"
      },
      marionette: {
        deps: ["backbone"],
        exports: "Marionette"
      },
      d3: {
        exports: "d3"
      },
      polyhedron: {
        deps: ["d3"],
        exports: "polyhedron"
      }
    },
    name: "app",
    out: "app.min.js"
  });

  require(["js/app"], function(App) {
    return App.start();
  });

  requirejs(["jquery", "d3"], function($, d3, polyhedron) {
    (function($, d3, polyhedron, window, undefined_) {
      var $doc;
      return $doc = $(document);
    })($, window);
  });

}).call(this);
