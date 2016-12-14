function validateFileSize() {
  var file = $('#new_report form input img');
  return typeof files != 'undefined' && filesize === 1;
}

$('.report-form form').submit(function() {
  // validateFileSize();
});

function populateLatLng() {
  $('#report_latitude').val(localStorage.getItem('clickedLat') || localStorage.getItem('lat'));
  $('#report_longitude').val(localStorage.getItem('clickedLng') || localStorage.getItem('lng'));
}

$(document).on('turbolinks:load', function() {
  populateLatLng();
});
