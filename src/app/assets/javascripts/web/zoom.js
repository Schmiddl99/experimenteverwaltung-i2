function initisalizeZoom(){
  $('.zoom').zoom({ on:'click', magnify: 1.5 });
  $("#zoom_range").change(function (){
    $('.zoom').trigger('zoom.destroy');
    $('.zoom').zoom({ on:'click', magnify: $(this).val() / 100 });
    $('#zoom-label').text("Zoom: +" + $(this).val() + "x")
  })
}