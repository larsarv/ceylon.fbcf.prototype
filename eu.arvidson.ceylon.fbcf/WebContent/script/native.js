// Some utillity functions
window.log$native = function(arg) {
	if (console) {
		console.log(arg);
	}
};
window.now$native = function() {
	return Date.now();
};
window.nodeListToArray$native = function(nodeList) {
	var array = [];
	// iterate backwards ensuring that length is an UInt32
	for (var i = 0; i < nodeList.length; i++) { 
		array.push(nodeList[i]);
	}
	return array;
};
window.setObjectProperty$native = function(obj, name, val) {
	obj[name] = val;
};
window.getObjectProperty$native = function(obj, name) {
	return obj[name];
};

window.compareNative$native = function(obj1, obj2) {
	return obj1 == obj2;
}


window.setObjectPropertyNative = function(obj, name, val) {
	obj[name] = val;
};
window.getObjectPropertyNative = function(obj, name) {
	return obj[name];
};
