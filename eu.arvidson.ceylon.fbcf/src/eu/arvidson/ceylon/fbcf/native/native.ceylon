/*
shared native interface UnknownNative {
}
shared native UnknownNative castToCeylon(UnknownNative obj) {
	return nothing;
}
*/
shared native void log(String arg);
shared native Integer now();
shared native void nodeListToArray(dynamic nodeList);
shared native void setObjectProperty(dynamic obj, String name, dynamic val);
shared native dynamic getObjectProperty(dynamic obj, String name);
shared native Boolean compareNative(dynamic obj1, dynamic obj2);