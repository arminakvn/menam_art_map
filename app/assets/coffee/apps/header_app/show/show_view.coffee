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
    )

  App.HeaderApp.View