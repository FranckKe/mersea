// function getEXIFLatLng(img) {
//   EXIF.getData(img, function() {
//     var lat = EXIF.getTag(this, 'GPSLatitude');
//     var lng = EXIF.getTag(this, 'GPSLontitude');
//     var latLng;
//
//     console.log('lat lng', lat, lng);
//
//     if (typeof lat !== 'undefined' && typeof lng !== 'undefined') {
//       latLng = {
//         'lat': lat[0],
//         'lng': lng[0]
//       };
//     }
//   });
//
//   return latLng;
// }

function getLastKnownPosition() {
  var latLng;
  var options = {
    maximumAge: 60000,
    timeout: 10000,
    enableHighAccuracy: true
  };

  function error() {
    latLng = {
      'lat': localStorage.getItem('lat'),
      'lng': localStorage.getItem('lng')
    };
    console.log("Position from local");
    populateLatLng(latLng.lat, latLng.lng);
  };

  if ("geolocation" in navigator) {
    // Hack to force a second call for better results
    navigator.geolocation.getCurrentPosition(function () {}, function () {}, {maximumAge: 0, timeout: 0});

    navigator.geolocation.getCurrentPosition(function(position) {
      latLng = {
        'lat': position.coords.latitude,
        'lng': position.coords.longitude
      };
      console.log("Position updated");
      populateLatLng(latLng.lat, latLng.lng);
    },
    error,
    options
    );
  }
}

function populateLatLng(lat, lng) {
  if (typeof lat !== 'undefined' && lat !== null && typeof lng !== 'undefined' && lng !== null) {
    $('#report_latitude').val(lat);
    $('#report_longitude').val(lng);
  }
}

function validateFileSize() {
  var file = $('#new_report form input img');
  return typeof files != 'undefined' && filesize === 1;
}

function parseGeoloc() {
  getLastKnownPosition();
  // latLng = getEXIFLatLng("#new_report .card img");
  // if(typeof latLng !== 'undefined' && latLng !== null ) {
  //   populateLatLng (latLng.lat, latLng.lng);
  // }
}

$('.report-form form').submit(function() {
  parseGeoloc();
  // validateFileSize();
});

$(document).on('turbolinks:load', function() {

});
