define ["js/app"], (App) ->
  App.module "OrgApp", (OrgApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "organization/:s":"showOrganization"
    )
    API =
      showOrganization: (s)->
        require ["js/apps/org_app/show/show_controller"], ->
          App.OrgApp.Show.Controller.showOrganization(s)
    App.addInitializer ->
      new App.Router
          controller: API
  App.OrgApp
