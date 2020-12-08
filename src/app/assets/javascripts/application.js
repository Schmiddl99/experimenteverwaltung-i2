//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require cocoon
//= require jquery.zoom.min
//= require jquery-ui
//= require_tree ./web
$(document).on('turbolinks:load', function(){
  sortable();
  nestedTrigger();
  initisalizeZoom();
  experimentsManager("equipment", ["name", "location", "inventory_nr", "adhoc", "equipment"], "equipment");
  experimentsManager("danger", ["name", "label", "adhoc"], "dangers");
})
