define ["marionette"], (Marionette) ->

  App = new Marionette.Application()
  App.vent = new Backbone.Wreqr.EventAggregator()

  App.addRegions
    footerRegion: "#footer-region"
    headerRegion: "#header-region"
    biosRegion: "#bios-region"
    mainRegion: "#main-region"

  # route helpers
  App.navigate= (route, options = {}) ->
    route = "#" + route if route.charAt(0) is "/"
    Backbone.history.navigate route, options

  App.getCurrentRoute = ->
    Backbone.history.fragment

  App.on "initialize:before", ->
    
  App.on "initialize:after", ->
    require ["js/apps/header_app/header_app", "js/apps/main_app/main_app", "js/apps/map_app/map_app", "js/apps/footer_app/footer_app", "js/apps/person_app/person_app", "js/apps/org_app/org_app"], ->
      console.log "Marionette Application Started"
      if Backbone.history
        Backbone.history.start()
        App.navigate("/", trigger: true) if App.getCurrentRoute() is ""
        # App.trigger "landing:home"
        # if App.getCurrentRoute() is ""
          # App.navigate "header"
          # App.trgigger "header:show"
          # App.navigate "main"
          # App.trigger "landing:home"

  App.vent.on "personFired", ->
    App.navigate "/person", trgigger: true
  
  App.vent.on "locationFired", ->
    console.log "locationFired"
    # App.module("PersonApp").stop()
    App.navigate "/location", trgigger: true
  
  App.vent.on "organizationFired", ->
    console.log "app triggered"
    App.navigate "/organization", trgigger: true
      # App.
  # App.addInitializer ->
    # require ["js/apps/header_app/header_app"], ->
      # App.module("HeaderApp").start()

  App