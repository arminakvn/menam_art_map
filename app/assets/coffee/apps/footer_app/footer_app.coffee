define ["js/app"], (App) ->
  App.module "FooterApp", (FooterApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        footer:"showFooter"
    )
    API =
      showFooter: ->
        require ["js/apps/footer_app/show/show_controller"], ->
          App.FooterApp.Show.Controller.showFooter()

    # App.on "header:show", ->

      # console.log("API.showHeader()")
      

    App.addInitializer ->
      new App.Router(controller: API)
      API.showFooter()
  App.FooterApp
