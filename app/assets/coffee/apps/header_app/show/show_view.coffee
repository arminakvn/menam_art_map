define ["js/app", "tpl!js/apps/header_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "HeaderApp.View", (View, App, Backbone, Marionette, $, _) ->

    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
      events:
      	"click #location":"locationFired"
      	"click #person":"personFired"
      	"click #organization":"organizationFired"
      	"click #biotraj":"biotrajFired"
      locationFired: (e) =>
        App.vent.trigger "locationFired"
      personFired: (e) =>
      	App.vent.trigger "personFired"
      organizationFired: (e) =>
        App.vent.trigger "organizationFired"
      biotrajFired: (e) =>
    )

  App.HeaderApp.View