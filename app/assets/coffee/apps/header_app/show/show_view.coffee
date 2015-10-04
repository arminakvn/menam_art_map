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
        "click #location":"locationFired"
        "click #person":"personFired"
        "click #organization":"organizationFired"
        "click #biotraj":"biotrajFired"
        "click #main":"mainFired"
        "click #menam-icon":"showModal"
      locationFired: (e) =>
        App.vent.trigger "locationFired"
      personFired: (e) =>
        App.vent.trigger "personFired"
      organizationFired: (e) =>
        App.vent.trigger "organizationFired"
      biotrajFired: (e) =>

      mainFired: (e) =>
        App.vent.trigger "mainFired"

      showModal: (e) =>
        console.log "showModal"
        App.NavApp.Show.Controller.showModal()
      onShow: ->

        $('input[name="my-checkbox"]').bootstrapSwitch('state', false, true)
        $('input[name="my-checkbox"]').bootstrapSwitch('onText', 'Locations')
        $('input[name="my-checkbox"]').bootstrapSwitch('offText', 'Organizations')
        $('input[name="my-checkbox"]').bootstrapSwitch('size', 'small')
        $('input[name="my-checkbox"]').bootstrapSwitch('onColor', "default")
        $('input[name="my-checkbox"]').bootstrapSwitch('offColor', "default")
        $('input[name="my-checkbox"]').bootstrapSwitch('labelWidth', $("#statebio")*4)
        $('input[name="my-checkbox"]').bootstrapSwitch('onSwitchChange', (e) =>
          e.stopPropagation()
          # console.log "App.getCurrentRoute()", App.getCurrentRoute()
          name = App.NavApp.Show.Controller.showView.model.attributes.statelocation.replace "All locations > ", ""
          # console.log "name", name
          # console.log "state", $('input[name="my-checkbox"]').bootstrapSwitch('state')
          if $('input[name="my-checkbox"]').bootstrapSwitch('state') is true
            # console.log "state is true"
            # App.navigate "/", trigger: true
            # App.MainApp.Show.Controller.updateView('all')
            # App.MapApp.Show.Controller.resetMapHighlights()
            # App.MainApp.Show.Controller.updateView(name)
            App.execute("showLocationByName", name)
            App.navigate "#/location/#{name}", trgigger:  true
          else if (App.getCurrentRoute() == 'location/') and ($('input[name="my-checkbox"]').bootstrapSwitch('state') is false)
            App.navigate "#/organization/#{name}", trgigger: true
          else if $('input[name="my-checkbox"]').bootstrapSwitch('state') is false
            # console.log "App.getCurrentRoute()", App.getCurrentRoute()
            name = App.getCurrentRoute().replace "organization/", ""
            App.execute("showLocationByName", name)
            # App.vent.trigger "locationsFired"
        )
    )

  App.HeaderApp.View