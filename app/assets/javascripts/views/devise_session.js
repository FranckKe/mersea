$(document).on('turbolinks:load', function () {
  $('#new_user')
  .on('ajax:beforeSend', function (e, data, status, xhr) {
    $('#new_user .submit').addClass('hide');
    $('#new_user .loader-wrapper').removeClass('hide');
  })
  .on('ajax:success', function (e, data, status, xhr) {
    window.location.href = '/';
  })
  .on('ajax:error', function (e, data, status, xhr) {
    $('.status-message p').text(data.responseText);
    $('#new_user .loader-wrapper').addClass('hide');
    $('#new_user .submit').removeClass('hide');
  });
});
