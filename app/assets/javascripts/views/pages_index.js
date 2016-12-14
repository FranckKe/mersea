// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var locateLayer = L.layerGroup();

$(document).on('turbolinks:load', function() {

  // Map init
  var mapElement = $("#map");
  var markers = [];
  var markerCluster = L.markerClusterGroup({
    spiderfyOnMaxZoom: true,
    showCoverageOnHover: true,
    zoomToBoundsOnClick: true,
    removeOutsideVisibleBounds: true,
    maxClusterRadius: 8
  });

  if (mapElement.length > 0) {
    var map = L.map('map').setView([48.2520, -3.9301], 9);
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';

    L.tileLayer(
      'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; ' + mapLink,
        maxZoom: 18
      }).addTo(map);

    map.zoomControl.setPosition('topright');

    loadMarkers();

    map.locate({ watch: true, maximumAge: 60000, timeout: 30000, setView: false, maxZoom: 16 });
    map.on('locationfound', onLocationFound);
    map.on('locationerror', onLocationError);
  }

  function onLocationFound(e) {
      var radius = e.accuracy / 2;
      var marker = L.marker(e.latlng);
      var circle = L.circle(e.latlng, radius);

      locateLayer.clearLayers();

      localStorage.setItem("lat", e.latitude);
      localStorage.setItem("lng", e.longitude);

      locateLayer.addLayer(marker)
        .addLayer(circle)
        .addTo(map);
  }

  function onLocationError(e) {
      alert(e.message);
  }

  function loadMarkers(e) {
      var url = window.location.href + "/reports";

      $.ajax({
            type: "GET",
            url: url,
            success: function(data) {
              clearMarkers();
              displayMarkers(data);
            }
      });
  }

  function displayMarkers(data) {
      data.forEach(function(element, index, array) {
        var marker = L.marker([element.latitude, element.longitude]);

        marker.bindPopup("<b>"+element.tracer+"</b><br>"+element.name+"</b><br>"+element.reported_at);
        markers.push(marker);
        markerCluster.addLayer(marker);
      });
      map.addLayer(markerCluster);
  }

  function clearMarkers() {
    markers.forEach(function(element, index, array) {
      map.removeLayer(element);
    });
  }

});
