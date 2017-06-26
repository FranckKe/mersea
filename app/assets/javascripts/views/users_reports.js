$(document).on('turbolinks:load', function () {
  $('.user-reports__table').DataTable({
    'ajax': {
      'type': 'GET',
      'dataType': 'json',
      'url': '/users/' + $('.user-reports__table').attr('data-id') + '/reports'
    },
    'bDestroy': true,
    'columns': [
      { 'data': 'id' },
      { 'data': 'tracer.name' },
      { 'data': 'quantity' },
      { 'data': 'longitude' },
      { 'data': 'latitude' },
      { 'data': 'description' },
      { 'data': 'reported_at' },
      { 'data': 'status' }
    ],
    'createdRow': function (row, data, index) {
      $('td', row).eq(0).addClass('hide');
    },
    'initComplete': function (settings, json) {
      $('.user-reports__table thead th:first').addClass('hide');
    }
  });

  $('.user-reports__table tbody').on('click', 'tr', function () {
    var reportId = $(this).find('td:first').text();
    if (reportId !== 'No data available in table') {
      $.ajax({
        type: 'GET',
        url: '/reports/' + reportId + '/edit',
        dataType : 'script'
      });
    }
  });
});
