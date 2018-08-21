//= require froala_editor.min
//= require plugins/align.min
//= require plugins/char_counter.min
//= require plugins/code_beautifier.min
//= require plugins/code_view.min
//= require plugins/colors.min
//= require plugins/emoticons.min
//= require plugins/entities.min
//= require plugins/file.min
//= require plugins/font_family.min
//= require plugins/font_size.min
//= require plugins/fullscreen.min
//= require plugins/help.min
//= require plugins/image.min
//= require plugins/image_manager.min
//= require plugins/inline_style.min
//= require plugins/line_breaker.min
//= require plugins/link.min
//= require plugins/lists.min
//= require plugins/paragraph_format.min
//= require plugins/paragraph_style.min
//= require plugins/print.min
//= require plugins/quote.min
//= require plugins/save.min
//= require plugins/table.min
//= require plugins/special_characters.min
//= require plugins/url.min
//= require plugins/video.min
//= require languages/fr.js
//= require leaflet
//=require 'ra.slug'

$(document).on("rails_admin.dom_ready", function() {
  var svgIcon = function(color) {
    return (
      "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='26px' height='42px'><rect xmlns='http://www.w3.org/2000/svg' x='6.02' y='6.02' height='14.5' width='12.625' fill='#fff'/><path d='M12.7 0.7c-6.573 0-12.044 5.691-12.044 11.866 0 2.778 1.564 6.308 2.694 8.746l9.306 17.872 9.262-17.872c1.13-2.438 2.738-5.791 2.738-8.746 0-6.175-5.383-11.866-11.956-11.866zm0 7.155c2.584.017 4.679 2.122 4.679 4.71s-2.095 4.663-4.679 4.679c-2.584-.017-4.679-2.09-4.679-4.679 0-2.588 2.095-4.693 4.679-4.71z' fill='" +
      color +
      "' stroke='gray' stroke-width='1.1' stroke-linecap='round'/></svg>"
    );
  };

  var markerColorFieldEdit = $("#tracer_color");
  var markerColorParentEdit = markerColorFieldEdit.parent();

  if (markerColorFieldEdit !== null) {
    markerColorFieldEdit.css("width", "200px");
    if (typeof markerColorFieldEdit.attr("value") === "undefined") {
      markerColorFieldEdit.val("#126fc6");
    }
    markerColorParentEdit.append(svgIcon(markerColorFieldEdit.val()));
    var markerColorSvg = markerColorParentEdit.find("path")[0];
    markerColorFieldEdit.on("input", function() {
      markerColorSvg.setAttribute("fill", $(this).val());
    });
  }

  var markerColorFieldShowLabel = $(".color_field.color_type.label.label-info");
  if (markerColorFieldShowLabel !== null) {
    var markerColorParentShow = markerColorFieldShowLabel.parent().next();
    var markerColorShow = markerColorParentShow.children().text();
    markerColorParentShow.append(svgIcon(markerColorShow));
  }

  var mapElement = $("#map")[0];
  if (mapElement !== undefined) {
    var latlng = [mapElement.dataset.lat, mapElement.dataset.lng];
    var map = L.map("map").setView(latlng, 7);
    var mapLink = '<a href="http://openstreetmap.org">OpenStreetMap</a>';

    var osm = L.tileLayer(
      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      {
        attribution: "Map data &copy; " + mapLink,
        maxZoom: 18
      }
    );

    osm.addTo(map);

    var marker = L.marker(latlng, {
      icon: L.divIcon({
        className: "",
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [0, -26],
        html:
          '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="26" height="40"><rect xmlns="http://www.w3.org/2000/svg" x="6.02" y="6.02" height="14.5" width="12.625" fill="#fff"/><path d="M12.7 0.7c-6.573 0-12.044 5.691-12.044 11.866 0 2.778 1.564 6.308 2.694 8.746l9.306 17.872 9.262-17.872c1.13-2.438 2.738-5.791 2.738-8.746 0-6.175-5.383-11.866-11.956-11.866zm0 7.155c2.584.017 4.679 2.122 4.679 4.71s-2.095 4.663-4.679 4.679c-2.584-.017-4.679-2.09-4.679-4.679 0-2.588 2.095-4.693 4.679-4.71z" fill="#227bc9" stroke="gray" stroke-width="1.1" stroke-linecap="round"/></svg>'
      })
    }).addTo(map);
  }
});
