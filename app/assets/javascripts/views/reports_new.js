var file = $("form input img");

var filesize = ((file.size / 1024) / 1024).toFixed(4); // MB


if (typeof files != "undefined" && filesize < 3) {
  // OK
}

$("#newReport form").submit(function() {
  var latlng = localStorage.get("latlng");
  $("#report_latitude").val(latlng)
});


$(document).on('turbolinks:load', function() {
  if ($("#new_report").length > 0) {
    var lat = localStorage.getItem("lat");
    var lng = localStorage.getItem("lng");

    $("#report_latitude").val(lat);
    $("#report_longitude").val(lng);
  }
});
