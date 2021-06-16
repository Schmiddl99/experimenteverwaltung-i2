function experimentsManager(name, fields, path){
  if($("#new_experiment, .edit_experiment").length === 0) return;
  window[name] = {}
  $("#"+name+"-modal").on('hidden.bs.modal', function () {
    window[name] = {}
    $("#new_"+name).trigger("reset");
  })
  function button_html(data){
    data_attrs = ""
    fields.forEach(function(field) {
      data_attrs += " data-" + field + "='" + data[field] + "' "
    })
    data_attrs += " data-id='" + data.id + "' "
    return '<button class="btn btn-link times-nested-forms ' + name + '-modal"' + data_attrs + 'type="button"><i class="fa fa-edit"></i></button>'
  }
  function addCallbacks(){
    $("."+name+"-modal").click(function(){
      var self = $(this);
      window[name].id = self.data("id");
      fields.forEach(function(field) {
        if (field === "adhoc"){
          $("#"+name+"_adhoc").prop('checked', true);
        }else{
          $("#"+name+"_"+field).val(self.data(field));
        }
      })
      $("#"+name+"-modal").modal('show');
    })
  };
  function insertCallbacks(root){
    root.find("select."+name+"-select").on('change', function() {
      var el = $(this)
      var value = el.val();
      if (value === "new"){
        window[name].select = $(this);
        $("#"+name+"_adhoc").prop('checked', true);
        $("#"+name+"-modal").modal('show');
      }else{
        $.ajax({
          type: "GET",
          url: "/"+path+"/" + value + ".json",
          success: function( response ) {
            el.closest(".row").find(".edit-button-"+name).html(button_html(response));
            addCallbacks()
          }, 
        })       
      }
    });
  };
  insertCallbacks($('#' + name + '-wrapper'));
  $("#new_"+name).submit(function( event ) {
    event.preventDefault();
    var data = {
      authenticity_token: $('meta[name="csrf-token"]').attr("content")
    };
    data[name] = {}
    var type, url;
    fields.forEach(function(field) {
      if (field === "adhoc"){
        if ($("input#"+name+"_adhoc").is(':checked')){
          data[name].adhoc = 1
        }else{
          data[name].adhoc = 0
        }
      }else{
        data[name][field] = $("#"+name+"_"+field).val()
      }
    })
    if (window[name].id){
      type = "PATCH"
      url = "/"+path+"/" + window[name].id + ".json"
    }else{
      type = "POST"
      url = "/"+path+".json"
    }
    $.ajax({
      type: type,
      url: url,
      data: data,
      success: function( response ) {
        if (response.id){
          if (window[name].id){
            $("."+name+"-select > option[value='" + window[name].id + "']").text(data[name][fields[0]])
          } else {
            $("select."+name+"-select").append(new Option(data[name][fields[0]], response.id));
            if (window[name].select){
              data[name].id = response.id
              window[name].select.val(response.id);
              window[name].select.closest(".row").find(".edit-button-"+name+"").html(button_html(data[name]));
              addCallbacks()
            }
            $("select."+name+"-select").each(function() {
              var x = $(this).val()
              $(this).append($(this).find("option").remove().sort(function(a, b) {
                var at = $(a).text().toLowerCase(), bt = $(b).text().toLowerCase();
                return (at > bt)?1:((at < bt)?-1:0);
              }));
              $(this).val(x)
            });
            window[name].select = null
            $('#' + name + '-wrapper .selectpicker').selectpicker('refresh');
          }
          $("#"+name+"-modal").modal('hide');
        }else{
          alert("Speichern nicht möglich, bitte überprüfen Sie Ihere eingabe.")
        }
      },
    });
  })

  $('#' + name + '-wrapper .add_association').click(function(){
    $("#nested-new-"+$(this).data("type")).click()
  })
  $('#' + name + '-wrapper .nested-form').on('cocoon:after-insert', function(e, insertedItem) {
    e = $(insertedItem)
    e.attr("id", "nested-item-"+Date.now())
    e.find(".sort-input").val(e.parent().prevAll().length)
    nestedTrigger();
    sortable();
    insertCallbacks(e);
    e.find(".selectpicker").selectpicker();
  }).on('cocoon:before-remove', function(event, insertedItem) {
    var confirmation = confirm("Möchten Sie dies wirklich löschen?");
    if( confirmation === false ){
      event.preventDefault();
    }
  })
}
