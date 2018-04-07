$(document).on("turbolinks:load", function() {
  $("#geoloc")
    .leafletLocationPicker()
    .on("changeLocation", function(e) {
      $(".report_latitude input").val(e.latlng.lat);
      $(".report_longitude input").val(e.latlng.lng);
    });

  var reportedAtInput = $(".report_reported_at input");
  var datepicker = $(".datepicker-tracer-form").datepicker({
    onSelect: function(dateText) {
      $(this).change();
    }
  });

  datepicker.datepicker("option", $.datepicker.regional[I18n.currentLocale()]);
  datepicker.datepicker("option", "dateFormat", "yy-mm-dd");

  $(".datepicker-tracer-form").val(reportedAtInput.val());

  $("#report_date").change(function() {
    reportedAtInput.val(
      $.datepicker.formatDate("yy-mm-dd", datepicker.datepicker("getDate"))
    );
  });
});
