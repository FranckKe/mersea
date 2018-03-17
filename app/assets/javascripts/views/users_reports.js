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

  $(".user-reports__table").DataTable({
    language: {
      url: "//cdn.datatables.net/plug-ins/1.10.16/i18n/" + language + ".json"
    },
    ajax: {
      type: "GET",
      dataType: "json",
      url: "/users/" + $(".user-reports__table").attr("data-id") + "/reports"
    },
    bDestroy: true,
    columns: [
      { data: "id" },
      { data: "tracer.name" },
      { data: "quantity" },
      { data: "longitude" },
      { data: "latitude" },
      { data: "description" },
      { data: "reported_at" },
      { data: "status" }
    ],
    createdRow: function(row, data, index) {
      $("td", row)
        .eq(0)
        .addClass("hide");
    },
    initComplete: function(settings, json) {
      $(".user-reports__table thead th:first").addClass("hide");
    }
  });

  $(".user-reports__table tbody").on("click", "tr", function() {
    var reportNode = $(this).find("td:first");
    var reportId = $(this)
      .find("td:first")
      .text();
    if (!reportNode.hasClass("dataTables_empty")) {
      $.ajax({
        type: "GET",
        url: "/reports/" + reportId + "/edit",
        dataType: "script"
      });
    }
  });
});
