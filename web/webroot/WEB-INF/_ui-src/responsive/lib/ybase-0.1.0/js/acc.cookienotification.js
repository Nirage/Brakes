const coookienotification = {
  _autoload: ['checkCookie', 'setCookie', 'getCookies', 'getCookie'],

  checkCookie: function () {
    var brakescookie = ACC.coookienotification.getCookie('cookiePolicy');
    if (brakescookie != '') {
      $('.cookie-wrapper').hide();
    } else {
      $('.cookie-wrapper').show();
    }
  },

  setCookie: function (cname, cvalue, exdays) {
    if (cname != undefined) {
      var d = new Date();
      d.setTime(d.getTime() + exdays * 24 * 60 * 60 * 1000);
      var expires = 'expires=' + d.toUTCString();
      document.cookie = cname + '=' + cvalue + '; ' + expires + ' ;path=/';
    }
  },

  getCookie: function (cookie_name) {
    if (cookie_name != undefined) {
      if (document.cookie.length > 0) {
        var c_start = document.cookie.indexOf(cookie_name + '=');
        if (c_start != -1) {
          c_start = c_start + cookie_name.length + 1;
          var c_end = document.cookie.indexOf(';', c_start);
          if (c_end == -1) {
            c_end = document.cookie.length;
          }
          return unescape(document.cookie.substring(c_start, c_end));
        }
      }
    }
    return '';
  },

  getCookies: function () {
    var pairs = document.cookie.split(';');
    var cookies = {};
    for (var i = 0; i < pairs.length; i++) {
      var pair = pairs[i].split('=');
      cookies[pair[0]] = unescape(pair[1]);
    }
    return cookies;
  }
};

export default coookienotification;
