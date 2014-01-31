import ceylon.language.meta { type }
import eu.arvidson.ceylon.fbcf.native { setObjectProperty, log, getObjectProperty, compareNative, now }


shared interface ElementModifier<in Input> given Input satisfies Value {
	shared formal Linker<Input>? process(dynamic node);
}

shared class Property<in Input, out Result>(name, val) satisfies ElementModifier<Input> given Input satisfies Value given Result satisfies Value {
	shared String name;
	shared Binding<Input, Result> val;

	shared actual Linker<Input>? process(dynamic element) {
		dynamic {
			return PropertyLinker(element, name, val);
		}
	}
}

class OptStringPropertyController(dynamic element, String propertyName, Anything(String?) setter, currentVal) {
	variable String? currentVal;
	shared void update(String? newVal) {
		currentVal = newVal;
	}
	
	String emptyStringIfNull(String? val) {
		if (exists val) {
			return val;
		} else {
			return "";
		}
	}

	shared void updateViewEventHandler(TemplateInstanceEvent event) {
		String currentVal = emptyStringIfNull(this.currentVal);
		dynamic {
			String oldVal = emptyStringIfNull(getObjectProperty(element, propertyName));
			//log("opt string property update view: current '``currentVal``' old '``oldVal``'");
			if (oldVal != currentVal) {
				setObjectProperty(element, propertyName, currentVal);
			}
		}
	}
	shared void updateModelEventHandler(TemplateInstanceEvent event) {
		String currentVal = emptyStringIfNull(this.currentVal);
		dynamic {
			String newVal = emptyStringIfNull(getObjectProperty(element, propertyName));
			//log("opt string property update model: current '``currentVal``' new '``newVal``'");
			if (newVal != currentVal) {
				setter(newVal);
			}
		}
	}
}

class BooleanPropertyController(dynamic element, String propertyName, Anything(Boolean) setter, currentVal) {
	variable Boolean currentVal;

	shared void update(Boolean newVal) {
		currentVal = newVal;
	}

	shared void updateViewEventHandler(TemplateInstanceEvent event) {
		dynamic {
			Boolean oldVal = getObjectProperty(element, propertyName);
			//log("opt boolean property update view: current '``currentVal``' old '``oldVal``'");
			if (oldVal != currentVal) {
				setObjectProperty(element, propertyName, currentVal);
			}
		}
	}
	shared void updateModelEventHandler(TemplateInstanceEvent event) {
		dynamic {
			Boolean newVal = getObjectProperty(element, propertyName);
			//log("opt boolean property update model: current '``currentVal``' new '``newVal``'");
			if (newVal != currentVal) {
				setter(newVal);
			}
		}
	}

}

class PropertyLinker<in Input, out OutputGet, in OutputSet>(node, String name, Binding<Input, Value<OutputGet, OutputSet>> binding) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		value val = ctx.bind(input, binding);
		
		if (is Value<Boolean, Boolean> val) {
			BooleanPropertyController controller;
			Boolean currentValue = val.get();
			dynamic { 
				controller = BooleanPropertyController(node, name, val.set, currentValue);
				setObjectProperty(node, name, currentValue);
			}
			controller.update(currentValue);
			ctx.registerEventHandler(controller.updateModelEventHandler, updateModelEvent.asSet());
			ctx.registerEventHandler(controller.updateViewEventHandler, updateViewEvent.asSet());
			observe(val, controller.update, ctx.registerEventHandler);
		} else if (is Value<String?, String?> val) {
			OptStringPropertyController controller;
			String? currentValue = val.get();
			dynamic { 
				controller = OptStringPropertyController(node, name, val.set, currentValue);
				setObjectProperty(node, name, currentValue);
			}
			controller.update(currentValue);
			ctx.registerEventHandler(controller.updateModelEventHandler, updateModelEvent.asSet());
			ctx.registerEventHandler(controller.updateViewEventHandler, updateViewEvent.asSet());
			observe(val, controller.update, ctx.registerEventHandler);
//		} else if (is Value<String?,Nothing> val) {
			// Set only string propertiy
		} else {
			throw Exception("Type `` type(`OutputSet`).string `` not implemented yet in PropertyController");
		}
	}
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic { 
			return PropertyLinker<Input,OutputGet,OutputSet>(node, name, binding);
		}
	}
}

shared alias AttributeValue<in Input> given Input satisfies Value => Null|String|{String?*}|OptionalStringBinding<Input, Nothing>;
shared class Attribute<in Input>(name, val) satisfies ElementModifier<Input> given Input satisfies Value {
	shared String name;
	shared AttributeValue<Input> val;

	shared actual Linker<Input>? process(dynamic element) {
		dynamic {
			if (is String val) {
				element.setAttribute(name, val);
				return null;
			} else if (is {String?*} val) {
				value sb = StringBuilder();
				variable value first = true;
				for (String? tmp in val) {
					if (exists tmp) {
						if (first) {
							first = false;
						} else {
							sb.append(" ");
						}
						sb.append(tmp);
					}
				}
				element.setAttribute(name, sb.string);
				return null;
			} else if (is OptionalStringBinding<Input,Nothing> val) {
				return AttributeLinker<Input>(element, name, val);
			} else if (is Null val) {
				element.setAttribute(name, null);
				return null;
			} else {
				throw Exception("Unknown attribute value type '``type(val).string``' Input: '`` `Input`.string ``'");
			}
		}
	}
	
}

class AttributeController(dynamic element, String attributeName) {
	shared void update(String? newVal) {
		dynamic {
			String? oldVal = element.getAttribute(attributeName);
			//log("Updateing attribute new value: ``newVal else "<null>"`` old value: ``oldVal else "<null>"``");
			if (is String newVal) {
				if (is String oldVal, newVal.equals(oldVal)) {
					// Do nothing, same val
				} else {
					//log("Setting attribute to new value!");
					element.setAttribute(attributeName, newVal);
				}
			} else if (is Null newVal, exists oldVal) {
				element.removeAttribute(attributeName);
			}
		}
	}
	
}

class AttributeLinker<in Input>(node, String name, OptionalStringBinding<Input,Nothing> val) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		AttributeController controller;
		dynamic { 
			controller = AttributeController(node, name);
		}
		observe(ctx.bind(input, val), controller.update, ctx.registerEventHandler);
	}
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic { 
			return AttributeLinker<Input>(node, name, val);
		}
	}
}

shared interface Event {
}
class EventHandlerController<out ArgGet, in ArgSet>(arg, action, filter, ctx, event, node) {
	Value<ArgGet,ArgSet> arg;
	//Anything(InputGet,Event) action;
	Anything(Value<ArgGet,ArgSet>,Event) action;
	Boolean(Event)? filter;
	BindingLookup ctx;
	String event;
	
	shared void triggerAction(Event event) {
		ctx.updateModel();
		action(arg, event);
		ctx.updateView();
	}
	shared void handleEvent(Event event) {
		Integer start = now();
		
		if (exists filter) {
			if (filter(event)) {
				triggerAction(event);
			}
		} else {
			triggerAction(event);
		}
		
		Integer end = now();
		log("Event processed: ``end - start``ms");
	}
	
	variable dynamic node;
	shared void handleDisposeEvent(TemplateInstanceEvent event) {
		//log("Disposing event handler");
		dynamic {
			node.removeEventListener(event, this, false);
			node = null;
		}
	}
}

shared class EventHandlerLinker<in Input,out ArgGet, in ArgSet>(node, arg, event, action, filter) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	Binding<Input,Value<ArgGet,ArgSet>> arg;
	String event;
	Anything(Value<ArgGet,ArgSet>,Event) action;
	Boolean(Event)? filter;
	
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		dynamic {
			value controller = EventHandlerController(ctx.bind(input, arg), action, filter, ctx.bindingContext.getLookup(), event, node);
			node.addEventListener(event, controller, false);
			ctx.registerEventHandler(controller.handleDisposeEvent, disposeEvent.asSet());
		}
	}
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic { 
			return EventHandlerLinker(node, arg, event, action, filter); 
		}
	}
	
}
shared class EventHandler<in Input, out ArgGet, in ArgSet>(arg, event, action, filter = null) satisfies ElementModifier<Input> given Input satisfies Value {
	Binding<Input,Value<ArgGet,ArgSet>> arg;
	String event;
	Anything(Value<ArgGet,ArgSet>,Event) action;
	Boolean(Event)? filter;

	shared actual Linker<Input>? process(dynamic node) {
		dynamic { 
			return EventHandlerLinker(node, arg, event, action, filter);
		}
	}
	
}

alias ElementElementModifierWorkaround<in T> given T satisfies Value<Anything,Nothing> => ElementModifier<T>;
alias ElementComponentWorkaround<in T1,out T2> given T1 satisfies Value  => Component<T1,T2>;

shared class Element<in Input,out Type>(name, content = empty) satisfies Component<Input,Type> given Input satisfies Value {
	String name;
	{<ElementModifier<Input>|String|OptionalStringBinding<Input,Nothing>|Component<Input,Anything>|Null>*} content;
	
	shared actual Template<Input,Type> build() {
		value linkerListBuilder = SequenceBuilder<Linker<Input>>();
		dynamic elementNode;
		dynamic {
			dynamic element = document.createElement(name);
			elementNode = element;
			
			for (ElementModifier<Input>|String|OptionalStringBinding<Input,Nothing>|Component<Input,Anything>|Null child in content) {
				if (is String child) {
					if (!child.empty) {
						element.appendChild(document.createTextNode(child));
					}
				} else if (is ElementComponentWorkaround<Input,Anything> child) { // TODO Ceylon js bug!!! Was forced to do a type alias to get this to work....
					Template<Input,Anything> tmp = child.build();
					if (exists linker = tmp.linker) {
						linkerListBuilder.append(linker);
					}
					element.appendChild(tmp.node);
				} else if (is OptionalStringBinding<Input,Nothing> child) {
					Template<Input,String> tmp = Text(child).build();
					if (exists linker = tmp.linker) {
						linkerListBuilder.append(linker);
					}
					element.appendChild(tmp.node);
				} else if (is ElementElementModifierWorkaround<Input> child) { // TODO Ceylon js bug!!! Was forced to do a type alias to get this to work....
					if (exists tmp = child.process(element)) {
						linkerListBuilder.append(tmp);
					}
				} else if (is Null child) { 
				} else {
					throw Exception("Unknown content type '``type(child).string``' for '``(child else "<null>").string``' Input: '`` `Input`.string ``'");
					//log("Unknown content type '``type(child).string``' for '``child.string``' Input: '`` `Input`.string ``'");
				}
			}
			
			{Linker<Input>*} linkers = linkerListBuilder.sequence;
			if (linkers.empty) {
				return Template<Input,Type>(elementNode, null);
			} else if (linkers.size == 1) {
				return Template<Input,Type>(elementNode, linkers.first);
			} else {
				return Template<Input,Type>(elementNode, SeqenceLinker<Input>(elementNode, linkers));
			}
		}
	}
}
