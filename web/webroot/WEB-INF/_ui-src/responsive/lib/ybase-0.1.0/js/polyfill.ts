import 'core-js/stable';
import 'regenerator-runtime/runtime';
import 'element-closest-polyfill';

// Missing forEach on NodeList for IE11
if (window.NodeList && !NodeList.prototype.forEach) {
  NodeList.prototype.forEach = Array.prototype.forEach;
}
