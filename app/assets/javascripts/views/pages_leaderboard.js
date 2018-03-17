$(document).on("turbolinks:load", function() {
  var language = I18n.currentLocale();
  switch (I18n.currentLocale()) {
    case "en":
      language = "English";
      break;
    case "fr":
      language = "French";
      break;
    case "es":
      language = "Spanish";
      break;
    default:
      language = "English";
  }

  $(".palmares__table").DataTable({
    language: {
      url: "//cdn.datatables.net/plug-ins/1.10.16/i18n/" + language + ".json"
    }
  });
});
