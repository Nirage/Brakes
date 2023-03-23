// ************DEBOUNCE FUNC.****************/
// taken from https://underscorejs.org/#debounce
// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// N milliseconds. If `immediate` is passed, trigger the function on the
// leading edge, instead of the trailing.
function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this,
      args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
}

function array_unique(array) {
  return array.filter(function(el, index, arr) {
    return index == arr.indexOf(el);
  });
}

// ************PubSub FUNC.****************/
// https://gist.github.com/learncodeacademy/777349747d8382bfb722
//
// Publish example:
// window.customEvents.emit("moreProductsLoaded");
// Subscribe example"
// window.customEvents.on("moreProductsLoaded", function() {
//   console.info("load more is done");
// });
//
var customEvents = {
  events: {},
  on: function(eventName, fn) {
    this.events[eventName] = this.events[eventName] || [];
    this.events[eventName].push(fn);
  },
  off: function(eventName, fn) {
    if (this.events[eventName]) {
      for (var i = 0; i < this.events[eventName].length; i++) {
        if (this.events[eventName][i] === fn) {
          this.events[eventName].splice(i, 1);
          break;
        }
      }
    }
  },
  emit: function(eventName, data) {
    if (this.events[eventName]) {
      this.events[eventName].forEach(function(fn) {
        fn(data);
      });
    }
  }
};
