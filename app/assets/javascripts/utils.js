function urlJoin() {
  var input = arguments;
  var options = {};

  if (typeof arguments[0] === 'object') {
    // new syntax with array and options
    input = arguments[0];
    options = arguments[1] || {};
  }

  var joined = [].slice.call(input, 0).join('/');
  return normalize(joined, options);
}

function normalize(str, options) {
    // make sure protocol is followed by two slashes
    str = str.replace(/:\//g, '://');

    // remove consecutive slashes
    str = str.replace(/([^:\s])\/+/g, '$1/');

    // remove trailing slash before parameters or hash
    str = str.replace(/\/(\?|&|#[^!])/g, '$1');

    // replace ? in parameters with &
    str = str.replace(/(\?.+)\?/g, '$1&');

    return str;
}
