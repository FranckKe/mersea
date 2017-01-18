// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var locateLayer = L.layerGroup();
var clickLayer = L.layerGroup();
var plusIcon = L.icon({
  iconUrl: 'marker_plus.png',
  iconSize:     [32, 32],
  iconAnchor:   [16, 32],
  popupAnchor:  [0, -32]
});
var defaultIcon = L.icon({
  iconUrl: 'marker.png',
  iconSize:     [25, 41],
  iconAnchor:   [12, 41],
  popupAnchor:  [0, -26]
});

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
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; ' + mapLink,
        maxZoom: 18
      }).addTo(map);

    map.zoomControl.setPosition('topright');

    loadMarkers();

    map.locate({ watch: true, maximumAge: 60000, timeout: 30000, enableHighAccuracy: true, setView: false, maxZoom: 16 });
    map.on('locationfound', onLocationFound);
    map.on('locationerror', onLocationError);

    map.on('click', onMapClick);
  }

  function onLocationFound(e) {
    var radius = e.accuracy / 2;
    var circle = L.circle(e.latlng, radius);

    locateLayer.clearLayers();

    localStorage.setItem("lat", e.latitude);
    localStorage.setItem("lng", e.longitude);

    locateLayer.addLayer(circle)
      .addTo(map);

    console.log("Position Updated");
  }

  function onLocationError(e) {
    console.log(e.message);
  }

  function loadMarkers(e) {
      var url = urlJoin(window.location.href, "reports");

      $.ajax({
            type: "GET",
            url: url,
            success: function(data) {
              clearMarkers(markers);
              displayMarkers(data);
            }
      });
  }

  function displayMarkers(data) {
      data.forEach(function(element, index, array) {
        var marker = L.marker([element.latitude, element.longitude], {icon: defaultIcon});

        marker.bindPopup("<b>"+element.tracer+"</b><br>"+element.name+"</b><br>"+element.reported_at);
        markers.push(marker);
        markerCluster.addLayer(marker);
      });
      map.addLayer(markerCluster);
  }

  function clearMarkers(array) {
    array.forEach(function(element, index, array) {
      map.removeLayer(element);
    });
  }

  function onMapClick(e) {
    clickLayer.clearLayers();
    var markerClick = new L.marker(e.latlng, {icon: plusIcon});
    clickLayer.addLayer(markerClick).addTo(map);

    markerClick.bindPopup('<a href="/tracers"><i class="fi-plus"></i> Ajouter un témoignage</a>');
    localStorage.setItem("clickedLat", e.latlng.lat);
    localStorage.setItem("clickedLng", e.latlng.lng);
    markerClick.openPopup();
  }

});
