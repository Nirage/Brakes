Handlebars.registerHelper("toLowerCase", function(str) {
  return str.toLowerCase();
});
Handlebars.registerHelper("toUpperCase", function(str) {
  return str.toUpperCase();
});

Handlebars.registerHelper("var", function(name, value) {
  this[name] = value;
});

Handlebars.registerHelper("contains", function(collection, item, options) {
  // string check
  if (typeof collection === "string") {
    if (collection.search(item) >= 0) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  }
  // "collection" check (objects & arrays)
  for (var prop in collection) {
    if (collection.hasOwnProperty(prop)) {
      if (collection[prop] == item) return options.fn(this);
    }
  }
  return options.inverse(this);
});

//adding coma for thousands -> 1000 to 1,000
Handlebars.registerHelper("formatPriceForDisplay", function(price) {
  return price.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
});

Handlebars.registerHelper("inc", function(value) {
  return parseInt(value) + 1;
});

Handlebars.registerHelper("ifCond", function(v1, operator, v2, options) {
  switch (operator) {
    case "==":
      return v1 == v2 ? options.fn(this) : options.inverse(this);
    case "===":
      return v1 === v2 ? options.fn(this) : options.inverse(this);
    case "!==":
      return v1 !== v2 ? options.fn(this) : options.inverse(this);
    case "<":
      return v1 < v2 ? options.fn(this) : options.inverse(this);
    case "<=":
      return v1 <= v2 ? options.fn(this) : options.inverse(this);
    case ">":
      return v1 > v2 ? options.fn(this) : options.inverse(this);
    case ">=":
      return v1 >= v2 ? options.fn(this) : options.inverse(this);
    case "&&":
      return v1 && v2 ? options.fn(this) : options.inverse(this);
    case "||": {
      return v1 || v2 ? options.fn(this) : options.inverse(this);
    }
    default:
      return options.inverse(this);
  }
});
Handlebars.registerHelper("md", function(text) {
  return new Handlebars.SafeString(text);
});

Handlebars.registerHelper("incIndex", function(value) {
  return parseInt(value) + 1;
});

Handlebars.registerHelper("add", function(a, b) {
  var sum = parseFloat(a) + parseFloat(b);
  return sum;
});

Handlebars.registerHelper("concat", function() {
  var outStr = "";
  for (var arg in arguments) {
    if (typeof arguments[arg] != "object") {
      outStr += arguments[arg];
    }
  }
  return outStr;
});

Handlebars.registerHelper("replaceEmptySpace", function(text, replace) {
  return text.toString().replace(/\s/g, replace);
});

//string and array length
Handlebars.registerHelper("length", function(value) {
  if (typeof value === "string" || Array.isArray(value)) {
    return value.length;
  }
  return 0;
});
// Encode characters
Handlebars.registerHelper("encodeURIComponent", function(str) {
  return encodeURIComponent(str);
});

Handlebars.registerHelper("switch", function(value, options) {
  this._switch_value_ = value;
  var html = options.fn(this); // Process the body of the switch block
  delete this._switch_value_;
  return html;
});

Handlebars.registerHelper("case", function(value, options) {
  if (value == this._switch_value_) {
    return options.fn(this);
  }
});

Handlebars.registerHelper("subString", function(passedString, startstring, endstring) {
  var theString = passedString.substring(startstring, endstring);
  return theString;
});

Handlebars.registerHelper("truncate", function(passedString, maxlength) {
  var truncatedString = passedString.slice(0, maxlength) + "...";
  return truncatedString;
});

Handlebars.registerHelper('subtract', function (a, b) {
  return parseInt(a) - parseInt(b);
});
