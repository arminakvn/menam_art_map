# coffescript output to app/assets/js directory
requirejs.config
  baseUrl: "assets"
  urlArgs: 'bust=' + Math.random() # cachebuster
  paths:
    backbone: "./bower_components/backbone-amd/backbone"
    localstorage: "./bower_components/backbone.localstorage/backbone.localstorage"
    jquery: "./bower_components/jquery/jquery"
    underscore: "./bower_components/underscore-amd/underscore"
    marionette: "./bower_components/backbone.marionette/lib/backbone.marionette"
    tpl: "./bower_components/requirejs-tpl/tpl"
    json2: "./bower_components/json2/json2"
    d3: "./bower_components/d3/d3"
    polyhedron: "./bower_components/d3-plugins/geo/polyhedron/polyhedron"
    topojson: "./bower_components/topojson/topojson"
    bootstrapswitch: "./bower_components/bootstrap-switch/dist/js/bootstrap-switch"

  shim:
    underscore:
      exports: "_"

    backbone:
      deps: ["jquery", "underscore", "json2"]
      exports: "Backbone"

    marionette:
      deps: ["backbone"]
      exports: "Marionette"

    d3:
      exports: "d3"

    polyhedron:
      deps: ["d3"]
      exports: "polyhedron"

    bootstrapswitch:
      deps: ["jquery"]
      exports: "bootstrapswitch"

  name: "app",
  out: "app.min.js"
# route helpers
require ["js/app"], (App) ->
  App.start()

requirejs [
  "jquery"
  "d3"
  "bootstrapswitch"
], ($, d3, polyhedron, bootstrapswitch) ->
  (($, d3, polyhedron, bootstrapswitch, window, undefined_) ->
    $doc = $(document)
  ) $, window
  return

