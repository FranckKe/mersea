// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var defaultMarkerColor = '#126fc6';
var locateLayer = L.layerGroup();
var clickLayer = L.layerGroup();
var plusIcon = L.icon({
  iconUrl: 'marker_plus.png',
  iconSize:     [32, 32],
  iconAnchor:   [16, 32],
  popupAnchor:  [0, -32]
});
var defaultIcon = function(color) {
  return L.divIcon({
    className: '',
    iconSize:     [25, 41],
    iconAnchor:   [12, 41],
    popupAnchor:  [0, -26],
    html: '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><rect xmlns="http://www.w3.org/2000/svg" x="6.02" y="6.02" height="14.5" width="12.625" fill="#fff"/><path d="M12.7 0.7c-6.573 0-12.044 5.691-12.044 11.866 0 2.778 1.564 6.308 2.694 8.746l9.306 17.872 9.262-17.872c1.13-2.438 2.738-5.791 2.738-8.746 0-6.175-5.383-11.866-11.956-11.866zm0 7.155c2.584.017 4.679 2.122 4.679 4.71s-2.095 4.663-4.679 4.679c-2.584-.017-4.679-2.09-4.679-4.679 0-2.588 2.095-4.693 4.679-4.71z" fill="' + color + '" stroke="gray" stroke-width="1.1" stroke-linecap="round"/></svg>'
  });
}

$(document).on('turbolinks:load', function () {
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
  var markerColor = {};

  if (mapElement.length > 0) {
    var map = L.map('map').setView([46.2276, -2.2137], 6);
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';

    L.tileLayer(
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; ' + mapLink,
        maxZoom: 18
      }).addTo(map);

    map.zoomControl.setPosition('topright');

    loadMarkers();

    map.locate({
      watch: true,
      maximumAge: 60000,
      timeout: 30000,
      enableHighAccuracy: true,
      setView: false,
      maxZoom: 16
    });
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
    var urlReports = urlJoin(window.location.href, "reports");
    var urlTracers = urlJoin(window.location.href, "tracers");
    $.getJSON(urlTracers, function (data) {
      for(var tracer in data) {
        markerColor[data[tracer].id] = data[tracer].color || defaultMarkerColor;
      }

      $.getJSON(urlReports, function (data) {
        clearMarkers(markers);
        displayMarkers(data);
      });
    });
  }

  function displayMarkers(data) {
    data.forEach(function (element, index, array) {
      var marker = L.marker([element.latitude, element.longitude], {
        icon: defaultIcon(markerColor[element.tracer_id])
      });

      marker.bindPopup("<b>" + element.tracer + "</b><br>" + element.name + "</b><br>" + element.reported_at);
      markers.push(marker);
      markerCluster.addLayer(marker);
    });
    map.addLayer(markerCluster);
  }

  function clearMarkers(array) {
    array.forEach(function (marker, index, array) {
      map.removeLayer(marker);
    });
  }

  function onMapClick(e) {
    clickLayer.clearLayers();
    var markerClick = new L.marker(e.latlng, {
      icon: plusIcon
    });
    clickLayer.addLayer(markerClick).addTo(map);

    markerClick.bindPopup('<a href="/tracers"><i class="fi-plus"></i> Ajouter un témoignage</a>');
    localStorage.setItem("clickedLat", e.latlng.lat);
    localStorage.setItem("clickedLng", e.latlng.lng);
    markerClick.openPopup();
  }

});
