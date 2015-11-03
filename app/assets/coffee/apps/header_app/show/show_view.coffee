define ["js/app", "tpl!js/apps/header_app/show/templates/_header.tpl", "tpl!js/apps/header_app/show/templates/_headers.tpl"], (App, headerTpl, headersTpl) ->
  App.module "HeaderApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.HeaderView = Marionette.ItemView.extend(
      template: headerTpl
      tagName: "li"
    )
    View.HeadersView = Marionette.CompositeView.extend(
      template: headersTpl
      itemView: View.HeaderView
      itemViewContainer: "ul"
      id:"menam-icon"
      events:
        "click #locations":"organizationFired"
        "click #person":"personFired"
        "click #organizations":"locationFired"
        "mouseover #organizations":"organizationMousover"
        "mouseout #organizations":"organizationMousout"
        "mouseover #locations":"locationMousover"
        "mouseout #locations":"locationMousout"
        "click #biotraj":"biotrajFired"
        "click #main":"mainFired"
        "click #menam-icon":"showModal"
      # locationFired: (e) =>
      #   # App.vent.trigger "locationFired"
      personFired: (e) =>
        # App.vent.trigger "personFired"
      locationFired: (e) =>
          console.log "App.state.current", App.state.current
        # if App.state.current == 0
          # $('#organizations').html ""
          # $('#organizations').html "Organizations"
          $('#locations').removeClass('navmodeOn')
          $('#locations').addClass('navmodeOff')
          $('#organizations').removeClass('navmodeOff')
          $('#organizations').addClass('navmodeOn')
          App.state.current = 0
          # App.vent.trigger "locationFired"
        # else
        #   # $('#organizations').html ""
        #   # $('#organizations').html "Locations"
        #   $('#organizations').removeClass('navmodeOn')
        #   $('#organizations').addClass('navmodeOff')
        #   $('#locations').removeClass('navmodeOff')
        #   $('#locations').addClass('navmodeOn')
        #   App.state.current = 0
        #   # App.navigate "/organization/#{App.NavApp.Show.Controller.showView.model.get('statebio')}", trgigger: true
        #   App.navigate "/", trgigger: true
          # App.vent.trigger "organizationFired"
      organizationFired: (e) =>
          console.log "App.state.current",App.state.current
        # if App.state.current == 0
          # $('#organizations').html ""
          # $('#organizations').html "Organizations"
        #   $('#locations').removeClass('navmodeOn')
        #   $('#locations').addClass('navmodeOff')
        #   $('#organizations').removeClass('navmodeOff')
        #   $('#organizations').addClass('navmodeOn')
        #   App.state.current = 1
        #   # App.vent.trigger "locationFired"
        # else
          # $('#organizations').html ""
          # $('#organizations').html "Locations"
          $('#organizations').removeClass('navmodeOn')
          $('#organizations').addClass('navmodeOff')
          $('#locations').removeClass('navmodeOff')
          $('#locations').addClass('navmodeOn')
          App.state.current = 1
          # App.navigate "/organization/#{App.NavApp.Show.Controller.showView.model.get('statebio')}", trgigger: true
          App.navigate "/", trgigger: true
          # App.vent.trigger "organizationFired"


      biotrajFired: (e) =>

      mainFired: (e) =>
        App.vent.trigger "mainFired"

      showModal: (e) =>
        console.log "showModal"
        App.NavApp.Show.Controller.showModal()

      organizationMousover: (e) =>
        $(e.target).css('cursor','pointer')
      organizationMousoout: (e) =>
        $(e.target).css('cursor','default')
      locationMousover: (e) =>
        $(e.target).css('cursor','pointer')
      locationMousoout: (e) =>
        $(e.target).css('cursor','default')
      onShow: ->

        # $('input[name="my-checkbox"]').bootstrapSwitch('onSwitchChange', (e) =>
        #   e.stopPropagation()
        #   # console.log "App.getCurrentRoute()", App.getCurrentRoute()
        #   name = App.NavApp.Show.Controller.showView.model.attributes.statelocation.replace "All locations > ", ""
        #   # console.log "name", name
        #   # console.log "state", $('input[name="my-checkbox"]').bootstrapSwitch('state')
        #   if $('input[name="my-checkbox"]').bootstrapSwitch('state') is true
        #     # console.log "state is true"
        #     # App.navigate "/", trigger: true
        #     # App.MainApp.Show.Controller.updateView('all')
        #     # App.MapApp.Show.Controller.resetMapHighlights()
        #     # App.MainApp.Show.Controller.updateView(name)
        #     App.execute("showLocationByName", name)
        #     App.navigate "#/location/#{name}", trgigger:  true
        #   else if (App.getCurrentRoute() == 'location/') and ($('input[name="my-checkbox"]').bootstrapSwitch('state') is false)
        #     App.navigate "#/organization/#{name}", trgigger: true
        #   else if $('input[name="my-checkbox"]').bootstrapSwitch('state') is false
        #     # console.log "App.getCurrentRoute()", App.getCurrentRoute()
        #     name = App.getCurrentRoute().replace "organization/", ""
        #     App.execute("showLocationByName", name)
            # App.vent.trigger "locationsFired"
        # )
    )

  App.HeaderApp.View