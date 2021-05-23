document.addEventListener("turbolinks:load", function() {
  const yearInput = document.getElementById("lecturer_week_year");
  if(yearInput !== null) {
    const weekInput = document.getElementById("lecturer_week_week");
    yearInput.addEventListener("input", function(event) {
      const data = JSON.parse(weekInput.dataset[yearInput.value]);
      while(weekInput.firstChild) {
        weekInput.removeChild(weekInput.firstChild);
      }

      $.each(data, function(week, dates) {
        const option = document.createElement("option");
        option.text = `KW ${week}. - ${dates.start_of_week}-${dates.end_of_week}`;
        option.value = week;
        weekInput.add(option);
      });
    })
  }
});
