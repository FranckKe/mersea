$(document).on("turbolinks:load", function() {
  var informationStatusMessage = $(".edit-user .status-message p");
  var editUserSubmit = $(".edit-user .submit");
  var editUserLoader = $(".edit-user .loader-wrapper");

  $(".edit-user")
    .on("ajax:beforeSend", function(e, data, status, xhr) {
      editUserSubmit.addClass("hide");
      editUserLoader.removeClass("hide");
    })
    .on("ajax:success", function(evt, data, status, xhr) {
      updateStatusMessage(informationStatusMessage, "success", data.message);
      if (I18n.currentLocale() !== $("#user_language").val()) {
        window.location.replace(window.location.pathname);
      }
    })
    .on("ajax:error", function(e, data, status, xhr) {
      updateStatusMessage(
        informationStatusMessage,
        "error",
        data.responseJSON.message
      );
    })
    .on("ajax:complete", function(evt, xhr, status, error) {
      editUserLoader.addClass("hide");
      editUserSubmit.removeClass("hide");
    });

  var passwordStatusMessage = $(
    ".simple_form.password-update .status-message p"
  );
  var passwordSubmit = $(".simple_form.password-update .submit");
  var passwordLoader = $(".simple_form.password-update .loader-wrapper");
  var newPassword = $(".new-password");
  var newPasswordConfirmation = $(".new-password.confirmation");

  $(".password-update input.new-password").on(
    "propertychange change click keyup input paste",
    function(event) {
      if (newPassword.val() === "" || newPasswordConfirmation.val() === "") {
        passwordSubmit.prop("disabled", true);
        updateStatusMessage(passwordStatusMessage);
      } else {
        if (newPassword.val() === newPasswordConfirmation.val()) {
          updateStatusMessage(passwordStatusMessage);
          passwordSubmit.prop("disabled", false);
        } else {
          updateStatusMessage(
            passwordStatusMessage,
            "error",
            I18n.translations[I18n.currentLocale()].users.me
              .new_password_not_match
          );
          passwordSubmit.prop("disabled", true);
        }
      }
    }
  );

  $(".simple_form.password-update")
    .on("ajax:beforeSend", function(e, data, status, xhr) {
      passwordSubmit.addClass("hide");
      passwordLoader.removeClass("hide");
    })
    .on("ajax:success", function(evt, data, status, xhr) {
      updateStatusMessage(passwordStatusMessage, "success", data.message);
    })
    .on("ajax:error", function(e, data, status, xhr) {
      updateStatusMessage(
        passwordStatusMessage,
        "error",
        data.responseJSON.message
      );
    })
    .on("ajax:complete", function(evt, xhr, status, error) {
      passwordSubmit.removeClass("hide");
      passwordLoader.addClass("hide");
    });
});
