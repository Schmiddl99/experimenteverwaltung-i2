//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require cocoon
//= require jquery.zoom.min
//= require jquery-ui
//= require bootstrap-datepicker.min
//= require bootstrap-datepicker.de.min
//= require bootstrap-select.min
//= require bootstrap-select-defaults-de_DE.min
//= require_tree ./web
$(document).on('turbolinks:load', function(){
  sortable();
  nestedTrigger();
  initisalizeZoom();
  experimentsManager("equipment", ["name", "location", "inventory_nr", "adhoc", "equipment"], "equipment");
  experimentsManager("danger", ["name", "label", "adhoc"], "dangers");
  $(".datepicker").datepicker("destroy");
  $(".datepicker").datepicker({
    orientation: "top",
    language: "de",
    startDate: new Date()
  });
  var pickers = $(".selectpicker")
  pickers.selectpicker("destroy");
  pickers.selectpicker();
})
