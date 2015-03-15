define ["js/app", "tpl!js/apps/header_app/show/templates/_header.tpl", "tpl!js/apps/header_app/show/templates/_headers.tpl"], (App, headerTpl, headersTpl) ->
  App.module "HeaderApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.HeaderView = Marionette.ItemView.extend(
      template: headerTpl
      tagName: "li" 
      # ui:
      #   location: "#location"
      #   person: "#person"
      #   organization: "#organization"
      #   biotraj: "#biotraj"
      # triggers:
      #   "click @ui.location":"location"
      #   "click @ui.person":"person"
      #   "click @ui.organization":"organization"
      #   "click @ui.biotraj":"biotraj"
      
      # onLocation: (e) =>
      #   console.log "event gets the fire"
      #   App.vent.trigger "locationFired"
      # # onPerson: (e) =>
      #   App.vent.trigger "personFired"
      # onOrganization: (e) =>
      #   App.vent.trigger "organizationFired"
      # onBiotraj: (e) =>
      # onShow: ->
      #   console.log "itemvire on show", @
    )
    View.HeadersView = Marionette.CompositeView.extend(
      template: headersTpl
      itemView: View.HeaderView
      itemViewContainer: "ul"
      events:
        "click #location":"locationFired"
        "click #person":"personFired"
        "click #organization":"organizationFired"
        "click #biotraj":"biotrajFired"
      locationFired: (e) =>
        App.vent.trigger "locationFired"
      personFired: (e) =>
        console.log "personFired in header"
        App.vent.trigger "personFired"
      organizationFired: (e) =>
        App.vent.trigger "organizationFired"
      biotrajFired: (e) =>
    )

  App.HeaderApp.View