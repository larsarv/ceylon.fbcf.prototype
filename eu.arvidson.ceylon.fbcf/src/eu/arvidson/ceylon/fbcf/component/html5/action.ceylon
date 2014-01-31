import eu.arvidson.ceylon.fbcf.component { TemplateDuplicationContext, Value, observe, ElementModifier, TemplateInstantiationContext, Linker, Binding }
class FokusController(dynamic node) {
	variable Boolean current = false;
	
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
	
}
class FocusLinker<in Input>(node, Binding<Input, Value<Boolean, Nothing>> binding) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		FokusController controller;
		dynamic {
			controller = FokusController(node);
		}
		observe(ctx.bind(input, binding), controller.update, ctx.registerEventHandler);
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
