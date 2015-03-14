define ["js/app", "tpl!js/apps/footer_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "FooterApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
    )

  App.FooterApp.View