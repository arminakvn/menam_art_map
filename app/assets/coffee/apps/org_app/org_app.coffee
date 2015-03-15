define ["js/app"], (App) ->
  App.module "OrgApp", (OrgApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "organization/":"showOrganization"
    )
    API =
      showOrganization: ->
        require ["js/apps/org_app/show/show_controller"], ->
          App.OrgApp.Show.Controller.showOrganization()
    App.addInitializer ->
      new App.Router
          controller: API
  App.OrgApp
