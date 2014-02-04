import eu.arvidson.ceylon.fbcf.base { Value, EventHandler, Binding }

shared EventHandler<Input,Anything(),Nothing> onClick<in Input>(Binding<Input,Value<Anything(),Nothing>> arg) given Input satisfies Value {
	return EventHandler(arg, "click", (Value<Anything(),Nothing> arg, dynamic event) {
		arg.get()();
		return null;
	});
}
shared EventHandler<Input,Anything(),Nothing> onDblClick<in Input>(Binding<Input,Value<Anything(),Nothing>> arg) given Input satisfies Value {
	return EventHandler(arg, "dblclick", (Value<Anything(),Nothing> arg, dynamic event) {
		arg.get()();
		return null;
	});
}
shared EventHandler<Input,Anything(),Nothing> onKeyup<in Input>(Binding<Input,Value<Anything(),Nothing>> arg) given Input satisfies Value {
	return EventHandler(arg, "keyup", (Value<Anything(),Nothing> arg, dynamic event) {
		arg.get()();
		return null;
	});
}
shared EventHandler<Input,Anything(),Nothing> onBlur<in Input>(Binding<Input,Value<Anything(),Nothing>> arg) given Input satisfies Value {
	return EventHandler(arg, "blur", (Value<Anything(),Nothing> arg, dynamic event) {
		arg.get()();
		return null;
	});
}


shared EventHandler<Input,Anything(), Nothing> onEnter<in Input>(Binding<Input, Value<Anything(), Nothing>> arg) given Input satisfies Value {
	return EventHandler(arg, "keyup", 
	(Value<Anything(),Nothing> arg, dynamic event) {
		arg.get()();
		return null;
	},
	(dynamic event) {
		dynamic  {
			if (event.keyCode == 13) {
				return true;
			}
		}
		return false;
	});
}

