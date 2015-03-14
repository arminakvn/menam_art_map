define ["js/app", "js/apps/person_app/show/show_view"], (App, View) ->
  App.module "PersonApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel =
      showPerson: ->
        showView = new View.ShowView()
        console.log "mainRegion", App.mainRegion
        # App.mainRegion.empty()

        App.mainRegion.show showView
        # require ["js/entities/person"], ->
          # getPerson = App.request "person"
          # $.when(getPerson).done (person) ->
            # showView = new View.ShowView(model: person)

            # App.mainRegion.show showView

  App.PersonApp.Show.Controller

