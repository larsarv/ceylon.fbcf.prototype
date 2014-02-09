import eu.arvidson.ceylon.fbcf.base { OptionalStringBinding, Value, Property, Binding }

shared Property<Input,Value<String?,String?>> propValue<in Input>(OptionalStringBinding<Input, String?> arg) given Input satisfies Value
	=> Property("value", arg);

String? toChecked(Boolean state) {
	if (state) { 
		return "true";
	} else { 
		return null; 
	}
}

shared Property<Input,Value<Boolean, Boolean>> propChecked<in Input>(Binding<Input, Value<Boolean, Boolean>> arg) given Input satisfies Value
	=> Property("checked", arg);

