
shared class SingletonSet<out Element>(Element item) satisfies Set<Element> given Element satisfies Object {
	
	shared actual Set<Element> clone() => SingletonSet(item);
	
	shared actual Set<Element> complement<Other>(Set<Other> set) given Other satisfies Object {
		if (set.contains(item)) {
			return emptySet;
		} else {
			return this;
		}
	}
	
	
	shared actual Set<Element&Other> intersection<Other>(Set<Other> set) given Other satisfies Object {
		if (is Other item, set.contains(item)) {
			return SingletonSet<Element&Other>(item);
		} else {
			return emptySet;
		}
	}
	
	class SingeltonSetIterator() satisfies Iterator<Element> {
		variable Boolean done = false;
		shared actual Element|Finished next() {
			if (done) {
				return finished;
			} else {
				done = true;
				return item;
			}
		}
	}
	shared actual Iterator<Element> iterator() => SingeltonSetIterator();
	
	shared actual Boolean equals(Object that) {
		if (is Set<Object> that, that.size == 1 && that.contains(item)) {
			return true;
		} else {
			return false;
		}
	}
	
	shared actual Integer hash => item.hash * 7;
	
	shared actual Set<Element|Other> union<Other>(Set<Other> set) given Other satisfies Object {
		 throw Exception("Not imlemented");
	}
	shared actual Set<Element|Other> exclusiveUnion<Other>(Set<Other> set) given Other satisfies Object {
		throw Exception("Not imlemented");
	}
	
}