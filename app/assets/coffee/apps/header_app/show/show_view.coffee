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
      events:
        "click #location":"locationFired"
        "click #person":"personFired"
        "click #organization":"organizationFired"
        "click #biotraj":"biotrajFired"
        "click #main":"mainFired"
      locationFired: (e) =>
        App.vent.trigger "locationFired"
      personFired: (e) =>
        App.vent.trigger "personFired"
      organizationFired: (e) =>
        App.vent.trigger "organizationFired"
      biotrajFired: (e) =>

      mainFired: (e) =>
        App.vent.trigger "mainFired"
    )

  App.HeaderApp.View