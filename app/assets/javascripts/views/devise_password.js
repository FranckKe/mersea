$(document).on("turbolinks:load", function() {
  var resetPasswordStatusMessage = $(".reset-password .status-message p");
  var resetPasswordSubmit = $(".reset-password .submit");
  var resetPasswordLoader = $(".reset-password .loader-wrapper");
  var resetPasswordPassword = $(".reset-password .password");
  var resetPasswordPasswordConfirmation = $(
    ".reset-password .password.confirmation"
  );

  $(".reset-password input.password").on(
    "propertychange change click keyup input paste",
    function(event) {
      if (
        resetPasswordPassword.val() === "" ||
        resetPasswordPasswordConfirmation.val() === ""
      ) {
        resetPasswordSubmit.prop("disabled", true);
        updateStatusMessage(resetPasswordStatusMessage);
      } else {
        if (
          resetPasswordPassword.val() ===
          resetPasswordPasswordConfirmation.val()
        ) {
          if (resetPasswordPassword.val().length < 6) {
            updateStatusMessage(
              resetPasswordStatusMessage,
              "error",
              I18n.t("devise.password.password_wrong_length")
            );
            resetPasswordSubmit.prop("disabled", true);
          } else {
            updateStatusMessage(resetPasswordStatusMessage);
            resetPasswordSubmit.prop("disabled", false);
          }
        } else {
          updateStatusMessage(
            resetPasswordStatusMessage,
            "error",
            I18n.t("devise.password.password_not_match")
          );
          resetPasswordSubmit.prop("disabled", true);
        }
      }
    }
  );

  $(".reset-password")
    .on("ajax:beforeSend", function(e, data, status, xhr) {
      resetPasswordSubmit.addClass("hide");
      resetPasswordLoader.removeClass("hide");
    })
    .on("ajax:success", function(evt, data, status, xhr) {
      updateStatusMessage(resetPasswordStatusMessage, "success", data.message);
      window.location.href = "/";
    })
    .on("ajax:error", function(e, data, status, xhr) {
      updateStatusMessage(
        resetPasswordStatusMessage,
        "error",
        data.responseJSON.message
      );
    })
    .on("ajax:complete", function(evt, xhr, status, error) {
      resetPasswordLoader.addClass("hide");
      resetPasswordSubmit.removeClass("hide");
    });
});
