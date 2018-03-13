$(document).on("turbolinks:load", function() {
  $("#geoloc")
    .leafletLocationPicker()
    .on("changeLocation", function(e) {
      $(".report_latitude input").val(e.latlng.lat);
      $(".report_longitude input").val(e.latlng.lng);
    });

  var reportedAtInput = $("#report_reported_at");

  $(".datepicker-tracer-form").val(reportedAtInput.val());
  $(".datepicker-tracer-form").datepicker({
    dateFormat: "yy-mm-dd",
    dayNames: [
      "Dimanche",
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi"
    ],
    dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
    dayNamesShort: ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"],
    monthNames: [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre"
    ],
    firstDay: 1
  });

  $(".datepicker-tracer-form").change(function() {
    var date = $(this).datepicker("getDate"),
      day = date.getDate(),
      month = date.getMonth() + 1,
      year = date.getFullYear();

    reportedAtInput.val(year + "-" + month + "-" + day);
  });
});
