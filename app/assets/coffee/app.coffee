define ["marionette", "spin"], (Marionette, Spinner) ->
  App = new Marionette.Application()
  App.vent = new Backbone.Wreqr.EventAggregator()
  # require ["js/entities/modal"], =>
  App.addRegions
    footerRegion: "#footer-region"
    headerRegion: "#header-region"
    biosRegion: "#bios-region"
    bioRegion: "#bio-region"
    mainRegion: "#main-region"
    navRegion: "#navigation-region"

  # route helpers
  App.navigate= (route, options = {}) ->
    route = "#" + route if route.charAt(0) is "/"
    Backbone.history.navigate route, options

  App.getCurrentRoute = ->
    Backbone.history.fragment

  App.on "initialize:before", ->
    # require ["js/entities/artist"], =>
    #         $.ajax '/artistsbygroup/2',
    #           type: 'GET'
    #           dataType: 'json'
    #           error: (jqXHR, textStatus, errorThrown) ->
    #             # $('body').append "AJAX Error: #{textStatus}"
    #           success: (data, textStatus, jqXHR) ->
    #             App.request "set:artist", data
    # require ["js/entities/artist_source"], =>                
    #         $.ajax '/artistssource',
    #           type: 'GET'
    #           dataType: 'json'
    #           error: (jqXHR, textStatus, errorThrown) ->
    #             # $('body').append "AJAX Error: #{textStatus}"
    #           success: (data, textStatus, jqXHR) ->
    #             App.request "set:artistsource", data
    App.state = {"current": 0}
    App.opts = 
      lines: 9
      length: 0
      width: 23
      radius: 60
      scale: 0.5
      corners: 1
      color: '#E1E0E0'
      opacity: 0.25
      rotate: 30
      direction: 1
      speed: 0.7
      trail: 66
      fps: 40
      zIndex: 2e9
      className: 'spinner'
      top: '50%'
      left: '50%'
      shadow: false
      hwaccel: true
      position: 'absolute'
    require ["js/entities/person_link"], => 
            $.ajax '/links',
              type: 'GET'
              dataType: 'json'
              error: (jqXHR, textStatus, errorThrown) ->
                # $('body').append "AJAX Error: #{textStatus}"
              success: (data, textStatus, jqXHR) ->
                App.request "set:personLink", data
                
  App.on "initialize:after", ->
    $.ajax '/distLocs',
              type: 'GET'
              dataType: 'json'
              error: (jqXHR, textStatus, errorThrown) ->
                # $('body').append "AJAX Error: #{textStatus}"
              success: (data, textStatus, jqXHR) ->
                App.list = data
                return
    require ["js/apps/header_app/header_app", "js/apps/bio_app/bio_app", "js/apps/main_app/main_app", "js/apps/map_app/map_app", "js/apps/footer_app/footer_app", "js/apps/person_app/person_app", "js/apps/org_app/org_app",  "js/apps/nav_app/nav_app"], ->
      console.log "Marionette Application Started"
      if Backbone.history
        Backbone.history.start()
        App.Entities = Backbone.Collections || {}
        App.Entity = Backbone.Models || {}
        App.navigate("/", trigger: true) if App.getCurrentRoute() is ""
        # App.trigger "landing:home"
        # if App.getCurrentRoute() is ""
          # App.navigate "header"
          # App.trgigger "header:show"
        # console.log "@collection", App.collection
  


  App.vent.on "spinnerLoading", (target)->
    console.log "spin", @
    console.log "spinnerLoading"
    App.spinner = new Spinner(App.opts).spin(target)

  App.vent.on "spinnerLoaded", ->
    App.spinner.stop()
    # target = document.getElementById('foo')
    # spinner = new Spinner(opts).spin(target)
  App.vent.on "personFired", ->
    App.navigate "/person", trgigger: true
  
  App.vent.on "locationFired", (l) ->
    App.navigate "/location/#{l}", trgigger: true
  
  App.vent.on "organizationFired", (s)->
    App.navigate "/organization/#{s}", trgigger: true

  App.vent.on "locationsFired", (l)->
    App.navigate "/#{l}", trgigger: true

  App.vent.on "showBioFired", (b)->
    App.navigate "/show"

  App.vent.on "mainFired", ->
    App.navigate "/", trigger: true
  App