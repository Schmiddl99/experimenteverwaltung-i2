function nestedTrigger() {
  $(".nested-input-trigger").change(function (){
    var input = $(this)[0];
    if (input.files && input.files[0]) {
      $(this).closest(".custom-file").find(".img-label, .doc-label").text(input.files[0].name)
      var preview = $(this).closest(".col-sm-10").find(".img-preview");
      var sort = $(this).closest(".col-sm-10").find(".sort-input");
      sort.val($(".img-preview").length)
      if (preview){
        preview.removeClass("hidden");
        var reader = new FileReader();
        reader.onload = function (e) {
           preview.attr('src', e.target.result).fadeIn('slow');
        }
        reader.readAsDataURL(input.files[0]);
      }
    }
    // Fügt neues Card an
    if (!$(this).data("val")){
      $(this).data("val", $(this).val())
      $("#nested-new-"+$(this).data("add-type")).click()
    }
  })
}
function sortable() {
  $(".sortable").sortable({
    stop : function(event, ui){
      _self = $(this)
      var i = 0
      $(this).sortable('toArray').forEach( function(e){
        if (e && e != "nested-new-media" && e.indexOf("_id") == -1){
          i++
          el = _self.find("#"+e.replace("_id", ""))
          el.find(".sort-input").val(i)
        }
      })
    }
  })
}