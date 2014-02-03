"Run the module `eu.arvidson.ceylon.jsinterop`."
shared void run() {
    
}

native dynamic interopMapCreate();
native dynamic interopMapGet(dynamic map, dynamic key);
native dynamic interopMapPut(dynamic map, dynamic key, dynamic item);
native dynamic interopMapRemove(dynamic map, dynamic key);
native dynamic interopMapEachEntry(dynamic map, dynamic fn);
native dynamic interopMapSize(dynamic map);

shared class JsMapWrapper<Key, Item>() given Key satisfies Object given Item satisfies Object {
	variable dynamic map;
	dynamic {
		map = interopMapCreate();
	}
	
	shared Item? get(Object key) {
		dynamic {
			return interopMapGet(map, key); 
		}
	}
	shared Item? put(Key key, Item item) {
		dynamic {
			return interopMapPut(map, key, item);
		}
	}
	shared Item? remove(Object key) {
		dynamic {
			return interopMapRemove(map, key);
		}
	}
	
	shared void clear() {
		dynamic {
			map = interopMapCreate();
		}
	}
	
	shared void eachEntry(Anything(Key, Item) fn) {
		dynamic {
			interopMapEachEntry(map, fn);
		}
	}

	shared Boolean empty {
		dynamic {
			return interopMapSize(map) == 0;
		}
	}
	shared Integer size {
		dynamic {
			return interopMapSize(map);
		}

	}
}