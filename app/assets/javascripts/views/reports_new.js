$(document).on("turbolinks:load", function() {
  $("#geoloc")
    .leafletLocationPicker()
    .on("changeLocation", function(e) {
      $(".report_latitude input").val(e.latlng.lat);
      $(".report_longitude input").val(e.latlng.lng);
    });

  var reportedAtInput = $("#report_reported_at");

  $(".datepicker-tracer-form").val(reportedAtInput.val());

  var datepicker = $(".datepicker-tracer-form").datepicker(
    $.datepicker.regional[I18n.currentLocale()]
  );

  $(".datepicker-tracer-form").change(function() {
    var date = $(this).datepicker("getDate"),
      day = date.getDate(),
      month = date.getMonth() + 1,
      year = date.getFullYear();

    reportedAtInput.val(year + "-" + month + "-" + day);
  });
});
