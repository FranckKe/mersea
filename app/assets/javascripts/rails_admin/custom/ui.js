$(document).on('rails_admin.dom_ready', function () {
  var svgIcon = function (color) {
    return "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='26px' height='42px'><rect xmlns='http://www.w3.org/2000/svg' x='6.02' y='6.02' height='14.5' width='12.625' fill='#fff'/><path d='M12.7 0.7c-6.573 0-12.044 5.691-12.044 11.866 0 2.778 1.564 6.308 2.694 8.746l9.306 17.872 9.262-17.872c1.13-2.438 2.738-5.791 2.738-8.746 0-6.175-5.383-11.866-11.956-11.866zm0 7.155c2.584.017 4.679 2.122 4.679 4.71s-2.095 4.663-4.679 4.679c-2.584-.017-4.679-2.09-4.679-4.679 0-2.588 2.095-4.693 4.679-4.71z' fill='" + color + "' stroke='gray' stroke-width='1.1' stroke-linecap='round'/></svg>";
  };

  var markerColorFieldEdit = $('#tracer_color');
  var markerColorParentEdit = markerColorFieldEdit.parent();

  if (markerColorFieldEdit !== null) {
    markerColorFieldEdit.css('width', '200px');
    markerColorParentEdit.append(svgIcon(markerColorFieldEdit.val()));
    var markerColorSvg = markerColorParentEdit.find('path')[0];
    markerColorFieldEdit.on('input', function () {
      markerColorSvg.setAttribute('fill', $(this).val());
    });
  }

  var markerColorFieldShowLabel = $('.color_field.color_type.label.label-info');
  if (markerColorFieldShowLabel !== null) {
    var markerColorParentShow = markerColorFieldShowLabel.parent().next();
    var markerColorShow = markerColorParentShow.children().text();
    markerColorParentShow.append(svgIcon(markerColorShow));
  }
});
