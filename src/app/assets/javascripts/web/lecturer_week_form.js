document.addEventListener("turbolinks:load", function() {
  var yearInput = document.getElementById("lecturer_week_year");
  if(yearInput !== null) {
    var weekInput = document.getElementById("lecturer_week_week");
    yearInput.addEventListener("input", function(event) {
      var data = JSON.parse(weekInput.dataset[yearInput.value]);
      while(weekInput.firstChild) {
        weekInput.removeChild(weekInput.firstChild);
      }

      $.each(data, function(week, dates) {
        var option = document.createElement("option");
        option.text = "KW " + week + ". - " + dates.start_of_week + "-" + dates.end_of_week;
        option.value = week;
        weekInput.add(option);
      });
    })
  }
});
