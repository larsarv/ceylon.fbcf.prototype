
require(['eu/arvidson/ceylon/jsinterop/1.0.0/eu.arvidson.ceylon.jsinterop-1.0.0'], function (module) {             
	// Native package
	
	module.log$native = function(arg) {
		if (console) {
			console.log(arg);
		}
	};
	module.now$native = function() {
		return Date.now();
	};
	module.nodeListToArray$native = function(nodeList) {
		var array = [];
		// iterate backwards ensuring that length is an UInt32
		for (var i = 0; i < nodeList.length; i++) { 
			array.push(nodeList[i]);
		}
		return array;
	};
	module.setObjectProperty$native = function(obj, name, val) {
		obj[name] = val;
	};
	module.getObjectProperty$native = function(obj, name) {
		return obj[name];
	};
	
	module.compareNative$native = function(obj1, obj2) {
		return obj1 == obj2;
	}
	
	
	module.setObjectPropertyNative = function(obj, name, val) {
		obj[name] = val;
	};
	module.getObjectPropertyNative = function(obj, name) {
		return obj[name];
	};

});


window.interopMapNextId = 0; 
window.interopMapCreate = function() {
	return { 
		id: interopMapNextId++,
		nextKey: 0,
		size: 0,
		dict: {},
	};
};

window.interopMapGet = function(map, key) {
	var keyId = "$interopMapId" + map.id;
	if (key.hasOwnProperty(keyId)) {
		var result = map.dict[key[keyId]];
		return result === undefined ? null : result.item;
	} else {
		return null;
	}
};

window.interopMapPut = function(map, key, item) {
	var keyId = "$interopMapId" + map.id;
	var result = undefined;
	var dictKey;
	if (key.hasOwnProperty(keyId)) {
		dictKey = key[keyId];
		result = map.dict[dictKey];
	} else {
		dictKey = map.nextKey++;
		key[keyId] = dictKey;
	}
	map.size += 1;
	map.dict[dictKey] = { key: key, item: item };
	
	return result === undefined ? null : result.item;
};
window.interopMapRemove = function(map, key) {
	var keyId = "$interopMapId" + map.id;
	var result = undefined;
	if (key.hasOwnProperty(keyId)) {
		dictKey = key[keyId];
		result = map.dict[dictKey];
		if (result !== undefined) {
			map.size -= 1;
		}
		delete map.dict[dictKey];
	}
	return result === undefined ? null : result.item;
};
window.interopMapEachEntry = function(map, fn) {
	for (var key in map.dict) {
		if (map.dict.hasOwnProperty(key)) {
			var entry = map.dict[key]; 
			fn(entry.key, entry.item);
		}
	}
};
window.interopMapSize = function(map) {
	return map.size;
};
