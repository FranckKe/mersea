// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require leaflet
//= require leaflet.markercluster
//= require leaflet.markercluster.layersupport
//= require materialMenu.min
//= require jquery.dataTables.min
//= require leaflet-locationpicker
//= require i18n
//= require i18n/translations
//= require_tree .

$(document).on('turbolinks:load', function () {
  $(document).foundation();
  var menu = new Menu;
  I18n.locale = $('body').data('locale')
  setTimeout(function () {
    $('.callout').trigger('close');
  }, 3500);
});

$.ajaxSetup({
  dataType: 'json'
})

function updateStatusMessage (node, status, message) {
  status = status || '';
  message = message || '';
  var multipleMessage = '';
  if (typeof message === 'object') {
    for (var field in message) {
      multipleMessage += field + ': ' + message[field] + '<br>';
    }
    message = multipleMessage;
    node.html(multipleMessage);
  } else {
    node.text(message);
  }
  node.removeClass();
  node.addClass(status);
}
