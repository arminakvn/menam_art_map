define ["js/app", "js/apps/header_app/show/show_view"], (App, View) ->
  App.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel =
      showHeader: ->
        # require ["js/entities/header"], ->
          # getHeader = App.request "header:entities"
          # $.when(getHeader).done (header) ->
            showView = new View.HeadersView()

            App.headerRegion.show showView

  App.HeaderApp.Show.Controller

