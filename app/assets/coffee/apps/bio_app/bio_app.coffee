define ["js/app"], (App) ->
  App.module "BioApp", (BioApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = false
    App.commands.setHandler 'showBio', (artist) ->
      API.showBio(artist)
      return
    App.commands.setHandler 'hideBio', () ->
      API.hideBio()
      return
    # App.commands.setHandler 'showBioArtist', (artist) ->
    #   API.showBioByArtist(artist)
      # return
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        # "bio/":"showBio"
        "bio/:artist":"showBio"
    )
    # App.vent.on 'show:LocationByGroup', (q) ->
    #   Backbone.history.navigate "location/#{q}", { trigger: true }
    API =
      # showBio: ->
      #   require ["js/apps/bio_app/show/show_controller"], ->
      #     App.BioApp.Show.Controller.showBio()
      #     console.log "inside API"


      hideBio: ()->
        require ["js/apps/bio_app/show/show_controller"], ->
          App.BioApp.Show.Controller.hideBio()

      showBio: (artist) ->
        require ["js/apps/bio_app/show/show_controller"], ->
          App.BioApp.Show.Controller.showBio(artist)
    
    App.addInitializer ->
      new App.Router
        controller: API
  App.BioApp