// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {

  // Map init
  var map = L.map('map').setView([48.2520, -3.9301], 9);

  var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';

  L.tileLayer(
    'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; ' + mapLink,
      maxZoom: 18
    }).addTo(map);

    map.zoomControl.setPosition('topright');
});
