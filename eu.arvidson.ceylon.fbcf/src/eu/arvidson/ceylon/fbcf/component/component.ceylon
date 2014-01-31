
shared interface Component<in Input, out Type> given Input satisfies Value {
	shared formal Template<Input, Type> build();
}

shared interface TemplateInstantiationContext {
	shared formal void invoke<in Input>(Linker<Input> linker, Input input) given Input satisfies Value;
	shared formal Result bind<in Input, out Result>(Input input, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value;
	shared formal void registerEventHandler(Anything(TemplateInstanceEvent) eventHandler, Set<TemplateInstanceEvent> events);
	shared formal BindingContext bindingContext;
}

shared interface TemplateDuplicationContext {
	shared formal Linker<Input> invoke<in Input>(Linker<Input> linker) given Input satisfies Value;
}

shared interface Linker<in Input> given Input satisfies Value {
	shared formal dynamic node;
	shared formal void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input);
	shared formal Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node);
}


shared class TemplateInstance(node, eventHandlers) {
	shared dynamic node;
	shared EventHandlers eventHandlers;
	//shared Type obj;

	shared void triggerEvent(TemplateInstanceEvent event) {
		eventHandlers.triggerEvent(event);
	}
}
shared class Template<in Input, out Type>(node, linker) given Input satisfies Value {
	shared dynamic node;
	shared Linker<Input>? linker;
	
	shared TemplateInstance instantiate(BindingLookup bindingLookup, Input input) {
		dynamic {
			dynamic copy = node.cloneNode(true);
			if (exists linker) {
				StdTemplateInstantiationContext ctx = createTemplateInstantiationContext(bindingLookup, node, copy);
				ctx.invoke(linker, input);
				
				return TemplateInstance(copy, ctx.getEventHandlers());
			} else {
				return TemplateInstance(copy, EventHandlers(empty, empty, empty, empty));
			}
		}
	}
	shared Template<Input,Type> duplicate() {
		dynamic {
			dynamic copy = node.cloneNode(true);
			if (exists linker) {
				TemplateDuplicationContext ctx = createTemplateDuplicationContext(node, copy);
				return Template(copy, ctx.invoke(linker));
			} else {
				return Template(copy, null);
			}
		}
	}

	shared Template<Input,NewType> retype<NewType>() { // TODO add lower bound type constraint when added to ceylon: given NewType abstracts Type {
		dynamic {
			return Template<Input,NewType>(node, linker);
		}
	}

}



shared class SeqenceLinker<in Input>(node, {Linker<Input>*} linkers) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input model) {
		for (Linker<Input> linker in linkers) {
			ctx.invoke(linker, model);
		}
	}
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		value builder = SequenceBuilder<Linker<Input>>();
		for (Linker<Input> linker in linkers) {
			builder.append(ctx.invoke(linker));
		}
		dynamic { 
			return SeqenceLinker(node, builder.sequence);
		}
	}

}


String optionalObjectToString(Object? val) {
	if (exists val) {
		return val.string;
	} else {
		return "";
	}
}

class TextController(dynamic textNode) {
	shared void update(Object? newVal) {
		
		String val = optionalObjectToString(newVal);
		dynamic {
			String oldVal = textNode.data;
			
			if (!val.equals(oldVal)) {
				textNode.data = val;
			}
		}
	}
}

class TextLinker<in Input>(node, Binding<Input,Value<Object?,Nothing>> binding) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		TextController controller; 
		dynamic { 
			controller = TextController(node);
		}
		observe(ctx.bind(input, binding), controller.update, ctx.registerEventHandler);
	}
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic { 
			return TextLinker(node, binding);
		}
	}
}

shared class Text<in Input>(Binding<Input,Value<Object?,Nothing>> binding) satisfies Component<Input,String> given Input satisfies Value {
	shared actual Template<Input,String> build() {
		dynamic {
			dynamic node = document.createTextNode("{TEXT}");
			
			return Template<Input,String>(node, TextLinker(node, binding));
		}
	}
}

class TransformLinker<in Input, out Result>(node, linker, transform) satisfies Linker<Input> given Input satisfies Value given Result satisfies Value {
	shared actual dynamic node;
	Linker<Result> linker;
	Binding<Input,Result> transform;
	
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic {
			return TransformLinker(node, linker, transform);
		}
	}
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		value transformedModel = ctx.bind(input, transform);
		ctx.invoke(linker, transformedModel);
	}
}
shared class Model<in Input, out Result, Type>(transform, content) satisfies Component<Input, Type> given Input satisfies Value given Result satisfies Value {
	Binding<Input,Result> transform;
	Component<Result,Type> content;
	
	shared actual Template<Input,Type> build() {
		value template = content.build();
		dynamic {
			if (exists templateLinker = template.linker) {
				return Template<Input,Type>(template.node, TransformLinker(template.node, templateLinker, transform));
			} else {
				return Template<Input,Type>(template.node, null);
			}
		}
	}
}

shared class TemplateComponent<in Input,Type>(template) satisfies Component<Input,Type> given Input satisfies Value {
	Template<Input,Type> template;

	shared actual Template<Input,Type> build() => template.duplicate();
}

