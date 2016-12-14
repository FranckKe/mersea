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
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require leaflet
//= require leaflet.markercluster
//= require jquery.touchSwipe.min
//= require exif.min
//= require_tree .

$(document).on('turbolinks:load', function () {
    $(document).foundation();
});

$(".menu-toggle-swipe").swipe({
    swipeLeft: function (event, distance, duration, fingerCount, fingerData) {
        $('#menu').foundation('close');
    },
    swipeRight: function (event, distance, duration, fingerCount, fingerData) {
        $('#menu').foundation('open');
    }
});

$(function () {
    var reportedAtInput = $('#report_reported_at');

    $('.datepicker-tracer-form').val(reportedAtInput.val());
    
    $('.datepicker-tracer-form').datepicker({
        dateFormat: "yy-mm-dd"
    });

    $('.datepicker-tracer-form').change(function () {
        var date = $(this).datepicker('getDate'),
            day = date.getDate(),
            month = date.getMonth() + 1,
            year = date.getFullYear();

        reportedAtInput.val(year + '-' + month + '-' + day);
    });
});