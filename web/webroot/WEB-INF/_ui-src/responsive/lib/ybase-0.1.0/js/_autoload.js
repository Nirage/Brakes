//################################################################
//#### Autoload
//################################################################
//
// ACC.sample={
// 	_autoload: [
// 		"samplefunction",
// 		["somefunction", "some expression to test"]
// 		["somefunction","some expression to test","elsefunction"]
// 	],

// 	samplefunction:function(){
// 		//... do some suff here, executed every time ...
// 	},

// 	somefunction:function(){
// 		//... do some suff here. if expression match ...
// 	},

// 	elsefunction:function(){
// 		//... do some suff here. if expression NOT match ...
// 	}

// }

//  // sample expression: $(".js-storefinder-map").length != 0

export default () => {
  for (const [section, obj] of Object.entries(ACC)) {
    if (Array.isArray(obj._autoload)) {
      obj._autoload.forEach((value) => {
        if (Array.isArray(value)) {
          if (value[1]) {
            ACC[section][value[0]]();
          } else {
            if (value[2]) {
              ACC[section][value[2]]();
            }
          }
        } else {
          ACC[section][value]();
        }
      });
    }
  }
};
