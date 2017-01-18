function validateFileSize() {
  var file = $('#new_report form input img');
  return typeof files != 'undefined' && filesize === 1;
}

$('.report-form form').submit(function () {
  // validateFileSize();
});

function populateLatLng() {
  $('#report_latitude').val(localStorage.getItem('clickedLat') || localStorage.getItem('lat'));
  $('#report_longitude').val(localStorage.getItem('clickedLng') || localStorage.getItem('lng'));
}

$(document).on('turbolinks:load', function () {
  populateLatLng();

  var reportedAtInput = $('#report_reported_at');

  $('.datepicker-tracer-form').val(reportedAtInput.val());
  $('.datepicker-tracer-form').datepicker({
    dateFormat: "yy-mm-dd"
  });

  $('.datepicker-tracer-form').change(function () {
    var date = $(this).datepicker('getDate'),
      day = date.getDate(),
      month = date.getMonth() + 1,
      year = date.getFullYear();

    reportedAtInput.val(year + '-' + month + '-' + day);
  });
});
