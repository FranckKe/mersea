$(document).on('turbolinks:load', function () {
  var registrationStatusMessage = $('.registration .status-message p');
  var registrationSubmit = $('.registration .submit');
  var registrationLoader = $('.registration .loader-wrapper');
  var registrationPassword = $('.registration .password');
  var registrationPasswordConfirmation = $('.registration .password.confirmation');

  $('input.password').on('propertychange change click keyup input paste', function (event) {
    if (registrationPassword.val() === '' || registrationPasswordConfirmation.val() === '') {
      registrationSubmit.prop('disabled', true);
      updateStatusMessage(registrationStatusMessage);
    } else {
      if (registrationPassword.val() === registrationPasswordConfirmation.val()) {
        if (registrationPassword.val().length < 6) {
          updateStatusMessage(registrationStatusMessage, 'error', 'Le mot de passe doit être de plus de 6 caractères');
          registrationSubmit.prop('disabled', true);
        } else {
          updateStatusMessage(registrationStatusMessage);
          registrationSubmit.prop('disabled', false);
        }
      } else {
        updateStatusMessage(registrationStatusMessage, 'error', 'Les mots de passes ne correspondent pas');
        registrationSubmit.prop('disabled', true);
      }
    }
  });

  $('.registration')
  .on('submit', function () {
    if (grecaptcha.getResponse().length === 0) {
      updateStatusMessage(registrationStatusMessage, 'error', 'Veuillez confirmer que vous n\'êtes pas un robot');
      return false;
    } else {
      return true;
    }
  })
  .on('ajax:beforeSend', function (e, data, status, xhr) {
    updateStatusMessage(registrationStatusMessage);
    registrationSubmit.addClass('hide');
    registrationLoader.removeClass('hide');
  })
  .on('ajax:success', function (evt, data, status, xhr) {
    updateStatusMessage(registrationStatusMessage, 'success', data.message);
    window.location.href = '/';
  })
  .on('ajax:error', function (e, data, status, xhr) {
    updateStatusMessage(registrationStatusMessage, 'error', data.responseJSON.message);
    if (grecaptcha.getResponse().length > 0) {
      grecaptcha.reset();
    }
  })
  .on('ajax:complete', function (evt, xhr, status, error) {
    registrationLoader.addClass('hide');
    registrationSubmit.removeClass('hide');
  });
});
