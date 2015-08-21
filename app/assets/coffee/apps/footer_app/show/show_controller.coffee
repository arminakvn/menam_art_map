define ["js/app", "js/apps/footer_app/show/show_view"], (App, View) ->
  App.module "FooterApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel =
      showFooter: ->
        showView = new View.ShowView()

        App.footerRegion.show showView
        # require ["js/entities/footer"], ->
        #   getHeader = App.request "footer"
        #   $.when(getFooter).done (footer) ->
        #     showView = new View.ShowView(model: footer)

        #     App.headerRegion.show showView

  App.FooterApp.Show.Controller

