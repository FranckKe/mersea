function validateFileSize() {
  var file = $('#new_report form input img');
  return typeof files != 'undefined' && filesize === 1;
}

$('.report-form form').submit(function() {
  // validateFileSize();
});

$(document).on('turbolinks:load', function() {

});
