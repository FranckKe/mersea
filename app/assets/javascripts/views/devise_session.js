$(document).on('turbolinks:load', function () {
  var signinStatusMessage = $('.status-message p');
  var signinSubmit = $('#new_user .submit');
  var signinLoader = $('#new_user .loader-wrapper');

  $('.new_user')
  .on('ajax:beforeSend', function (e, data, status, xhr) {
    signinSubmit.addClass('hide');
    signinLoader.removeClass('hide');
  })
  .on('ajax:success', function (e, data, status, xhr) {
    window.location.href = '/';
  })
  .on('ajax:error', function (e, data, status, xhr) {
    updateStatusMessage(signinStatusMessage, 'error', data.responseJSON.message)
    signinLoader.addClass('hide');
    signinSubmit.removeClass('hide');
  });
});
