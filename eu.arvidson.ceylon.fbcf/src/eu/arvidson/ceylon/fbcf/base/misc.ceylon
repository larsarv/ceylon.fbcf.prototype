
class OutputValue<Get, Set>(val, setter) extends BaseValue<Get,Set>() given Set satisfies Get {
	variable Get val;
	Anything(Set) setter;
	
	shared actual Get get() {
		return val;
	}
	
	shared actual void set(Set newValue) {
		val = newValue;
		setter(newValue);
	}
	shared void update(Get newValue) {
		val = newValue;
	}
	
}


class Content<Get,Set>(output, eventHandlers) given Set satisfies Get {
	shared OutputValue<Get,Set> output;
	shared EventHandlers eventHandlers;
}

class ShowIfExistsController<Input,Get,ArgumentSet,OutputSet,Type>(node, bindingLookup, fragmentTemplate, output, input, Anything(ArgumentSet) setter) given Get satisfies Object given ArgumentSet satisfies Get given OutputSet satisfies ArgumentSet given Input satisfies Value {
	dynamic node;
	BindingLookup bindingLookup;
	Template<Input,Type> fragmentTemplate;
	OutputBinding<Input,Value<Get,OutputSet>> output;
	Input input;
	variable Content<Get,ArgumentSet>? content = null;
	
	shared void update(Get? newVal) {
		if (exists newVal) {
			if (exists content = content) {
				content.output.update(newVal);
			} else {
				value eventHandlerRegistry = EventHandlerRegistry();
				value outputValue = OutputValue<Get,ArgumentSet>(newVal, setter);
				outputValue.init(eventHandlerRegistry.registerEventHandler, true);
				
				value lookup = SimpleBindingLookup(output, outputValue, bindingLookup, bindingLookup.updateModel, bindingLookup.updateView);
				value instance = fragmentTemplate.instantiate(TemplateInstanceContext(lookup, eventHandlerRegistry.registerEventHandler), input);
				
				value content = this.content = Content(outputValue, eventHandlerRegistry.createEventHandlers()); 
				
				dynamic {
					node.appendChild(instance.node);
				}
				content.eventHandlers.triggerEvent(initializeEvent);
			}
		} else {
			if (exists content = content) {
				// Clear
				dynamic {
					while (node.firstChild) {
						node.removeChild(node.firstChild);
					}
				}
				content.eventHandlers.triggerEvent(disposeEvent);
				this.content = null;
			}
		}
	}
	
	
	shared void eventHandler(TemplateInstanceEvent event) {
		if (exists content = content) {
			content.eventHandlers.triggerEvent(event);
		}
	}
} 
class ShowIfExistsLinker<in Input, out Get, in ArgumentSet, in OutputSet, out Type>(node, argument, output, fragmentTemplate) satisfies Linker<Input> given Get satisfies Object given ArgumentSet satisfies Get given OutputSet satisfies ArgumentSet given Input satisfies Value {
	shared actual dynamic node;
	Binding<Input,Value<Get?,ArgumentSet>> argument;
	OutputBinding<Input,Value<Get,OutputSet>> output;
	Template<Input,Type> fragmentTemplate;
	
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic {
			return ShowIfExistsLinker<Input,Get,ArgumentSet,OutputSet,Type>(node, argument, output, fragmentTemplate);
		}
	}
	
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		dynamic {
			value argumentValue = ctx.bind(input, argument);
			value controller = ShowIfExistsController(node, ctx.bindingContext.getLookup(), fragmentTemplate, output, input, argumentValue.set);
			observe(argumentValue, controller.update, ctx.registerEventHandler); 
			ctx.registerEventHandler(controller.eventHandler, allEventsSet);
		}
	}
}

shared class ShowIfExists<in Input, out Get, in ArgumentSet, in OutputSet,out Type>(argument, output, content) satisfies Component<Input,Type> given Get satisfies Object given OutputSet satisfies ArgumentSet given ArgumentSet satisfies Get given Input satisfies Value {
	Binding<Input,Value<Get?,ArgumentSet>> argument;
	OutputBinding<Input,Value<Get,OutputSet>> output;
	{FragmentContent<Input,Type>+} content;
	
	shared actual Template<Input,Type> build() {
		value fragmentTemplate = Fragment(content).build();
		dynamic {
			dynamic node = document.createElement("showifexists");
			return Template<Input,Type>(node, ShowIfExistsLinker(node, argument, output, fragmentTemplate));
		}
	}
	
}

class ShowIfTrueController<Input,Type>(node, bindingLookup, fragmentTemplate, input) given Input satisfies Value {
	dynamic node;
	BindingLookup bindingLookup;
	Template<Input,Type> fragmentTemplate;
	Input input;
	
	variable EventHandlers? eventHandlers = null;

	shared void update(Boolean newVal) {
		if (newVal) {
			if (exists eventHandlers = eventHandlers) {
			} else {
				value eventHandlerRegistry = EventHandlerRegistry();
				value instance = fragmentTemplate.instantiate(TemplateInstanceContext(bindingLookup, eventHandlerRegistry.registerEventHandler), input);
				
				value eventHandlers = this.eventHandlers = eventHandlerRegistry.createEventHandlers(); 
				
				dynamic {
					node.appendChild(instance.node);
				}

				eventHandlers.triggerEvent(initializeEvent);
			}
		} else {
			if (exists eventHandlers = eventHandlers) {
				// Clear
				dynamic {
					while (node.firstChild) {
						node.removeChild(node.firstChild);
					}
				}
				eventHandlers.triggerEvent(disposeEvent);
				this.eventHandlers = null;
			}
		}
	}
	
	
	shared void eventHandler(TemplateInstanceEvent event) {
		if (exists eventHandlers = eventHandlers) {
			eventHandlers.triggerEvent(event);
		}
	}
} 

class ShowIfTrueLinker<in Input, out Type>(node, condition, fragmentTemplate) satisfies Linker<Input> given Input satisfies Value {
	shared actual dynamic node;
	Binding<Input,Value<Boolean,Nothing>> condition;
	Template<Input,Type> fragmentTemplate;
	
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic {
			return ShowIfTrueLinker<Input,Type>(node, condition, fragmentTemplate);
		}
	}
	
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		dynamic {
			value conditionValue = ctx.bind(input, condition);
			value controller = ShowIfTrueController(node, ctx.bindingContext.getLookup(), fragmentTemplate, input);
			observe(conditionValue, controller.update, ctx.registerEventHandler); 
			ctx.registerEventHandler(controller.eventHandler, allEventsSet);
		}
	}
}


shared class ShowIfTrue<in Input,out Type>(condition, content) satisfies Component<Input,Type> given Input satisfies Value {
	Binding<Input,Value<Boolean,Nothing>> condition;
	{FragmentContent<Input,Type>+} content;
	
	shared actual Template<Input,Type> build() {
		value fragmentTemplate = Fragment(content).build();
		dynamic {
			dynamic node = document.createElement("showiftrue");
			return Template<Input,Type>(node, ShowIfTrueLinker(node, condition, fragmentTemplate));
		}
	}
	
}
