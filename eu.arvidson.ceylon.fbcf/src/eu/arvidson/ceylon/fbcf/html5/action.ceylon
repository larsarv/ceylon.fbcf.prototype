import eu.arvidson.ceylon.fbcf.base { TemplateDuplicationContext, Value, observe, ElementModifier, TemplateInstantiationContext, Linker, Binding, TemplateInstanceEvent, initializeEvent }

class FocusController(dynamic node, current) {
	variable Boolean current;

	shared void update(Boolean newVal) {
		if (newVal) {
			if (!current) {
				current = true;
				dynamic {
					node.focus();
				}
			}
		} else {
			current = false;
		}
	}
	
	shared void handleInitializeEvent(TemplateInstanceEvent event) {
		if (current) {
			dynamic {
				node.focus();
			}
		}
	}
}
class FocusLinker<in Input>(node, Binding<Input, Value<Boolean, Nothing>> binding) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		value val = ctx.bind(input, binding);
		FocusController controller;
		dynamic {
			controller = FocusController(node, val.get());
		}
		observe(val, controller.update, ctx.registerEventHandler);
		ctx.registerEventHandler(controller.handleInitializeEvent, initializeEvent.asSet());
	}
	
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic {
			return FocusLinker(node, binding);
		}
	}
}

class FocusElementModifier<in Input>(Binding<Input, Value<Boolean, Nothing>> arg) satisfies ElementModifier<Input> given Input satisfies Value {
	shared actual Linker<Input>? process(dynamic node) {
		dynamic {
			return FocusLinker(node, arg);
		}
	}
}
shared ElementModifier<Input> doFocus<in Input>(Binding<Input, Value<Boolean, Nothing>> arg) given Input satisfies Value {
	return FocusElementModifier(arg);
}
