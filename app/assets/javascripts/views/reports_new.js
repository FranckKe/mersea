var file = $("form input img");

var filesize = ((file.size / 1024) / 1024).toFixed(4); // MB


if (typeof files != "undefined" && filesize < 3) {
  // OK
}
