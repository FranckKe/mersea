// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var defaultMarkerColor = "#126fc6";
var locateLayer = L.layerGroup();
var clickLayer = L.layerGroup();
var plusIcon = L.icon({
  iconUrl: "marker_plus.svg",
  iconSize: [26, 40],
  iconAnchor: [13, 40],
  popupAnchor: [0, -32]
});

var defaultIcon = function(color) {
  return L.divIcon({
    className: "",
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [0, -26],
    html:
      '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="26" height="40"><rect xmlns="http://www.w3.org/2000/svg" x="6.02" y="6.02" height="14.5" width="12.625" fill="#fff"/><path d="M12.7 0.7c-6.573 0-12.044 5.691-12.044 11.866 0 2.778 1.564 6.308 2.694 8.746l9.306 17.872 9.262-17.872c1.13-2.438 2.738-5.791 2.738-8.746 0-6.175-5.383-11.866-11.956-11.866zm0 7.155c2.584.017 4.679 2.122 4.679 4.71s-2.095 4.663-4.679 4.679c-2.584-.017-4.679-2.09-4.679-4.679 0-2.588 2.095-4.693 4.679-4.71z" fill="' +
      color +
      '" stroke="gray" stroke-width="1.1" stroke-linecap="round"/></svg>'
  });
};

$(document).on("turbolinks:load", function() {
  // Map init
  var mapElement = $("#map");
  var markers = [];
  var control = L.control.layers(null, null, {
    collapsed: true,
    position: "bottomright"
  });
  var markerCluster = L.markerClusterGroup.layerSupport({
    spiderfyOnMaxZoom: true,
    showCoverageOnHover: true,
    zoomToBoundsOnClick: true,
    removeOutsideVisibleBounds: true,
    maxClusterRadius: 8
  });
  var tracerData = {};

  if (mapElement.length > 0) {
    var osm = L.tileLayer(
      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      {
        attribution: "Map data &copy; " + mapLink,
        maxZoom: 18
      }
    );

    var Esri_WorldImagery = L.tileLayer(
      "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
      {
        attribution:
          "Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community"
      }
    );

    var OpenSeaMap = L.tileLayer(
      "https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png",
      {
        attribution:
          'Map data: &copy; <a href="http://www.openseamap.org">OpenSeaMap</a> contributors'
      }
    );

    var map = L.map("map", {
      layers: [Esri_WorldImagery]
    }).setView([46.2276, -2.2137], 6);
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';

    control.addBaseLayer(Esri_WorldImagery, "Earth");
    control.addBaseLayer(osm, "Map");
    control.addOverlay(
      OpenSeaMap,
      'OpenSeaMap<div class="leaflet-control-layers-separator"></div>'
    );

    map.zoomControl.setPosition("topright");

    loadMarkers();

    map.on("click", onMapClick);
  }
  function loadMarkers(e) {
    var urlReports = urlJoin(window.location.origin, "reports");
    var urlTracers = urlJoin(window.location.origin, "tracers");
    $.getJSON(urlTracers, function(data) {
      for (var tracer in data) {
        tracerData[data[tracer].id] = {};
        tracerData[data[tracer].id].color =
          data[tracer].color || defaultMarkerColor;
        tracerData[data[tracer].id].name = data[tracer].name;
        tracerData[data[tracer].id].layerGroup = L.layerGroup();
      }

      $.getJSON(urlReports, function(data) {
        clearMarkers(markers);
        displayMarkers(data);
      });
    });
  }

  function displayMarkers(data) {
    data.forEach(function(element, index, array) {
      var marker = L.marker([element.latitude, element.longitude], {
        icon: defaultIcon(tracerData[element.tracer_id].color)
      });

      marker.bindPopup(
        "<b>" +
          element.tracer +
          "</b><br>" +
          element.name +
          "</b><br>" +
          element.reported_at
      );
      markers.push(marker);
      marker.addTo(tracerData[element.tracer_id].layerGroup);
    });

    for (var tracerId in tracerData) {
      tracerData[tracerId].layerGroup.addTo(markerCluster);
      control.addOverlay(
        tracerData[tracerId].layerGroup,
        '<span style="color:' +
          tracerData[tracerId].color +
          '">' +
          tracerData[tracerId].name +
          " (" +
          tracerData[tracerId].layerGroup.getLayers().length +
          ")</span>"
      );
    }

    markerCluster.addTo(map);
    control.addTo(map);
  }

  function clearMarkers(array) {
    array.forEach(function(marker, index, array) {
      map.removeLayer(marker);
    });
  }

  function onMapClick(e) {
    clickLayer.clearLayers();
    var markerClick = new L.marker(e.latlng, {
      icon: plusIcon
    });
    clickLayer.addLayer(markerClick).addTo(map);

    var popup = L.popup().setContent(
      '<a href="/tracers?locale=' +
        I18n.currentLocale() +
        "&lat=" +
        e.latlng.lat +
        "&lng=" +
        e.latlng.lng +
        '"><i class="fi-plus"></i> ' +
        I18n.translations[I18n.currentLocale()].pages.index.add_report +
        "</a>"
    );

    markerClick.bindPopup(popup);
    markerClick.openPopup();
    markerClick.on("popupclose", function(e) {
      map.removeLayer(markerClick);
    });
  }
});
