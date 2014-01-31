import eu.arvidson.ceylon.fbcf.native { log }

shared class SimpleEventHandler({Anything(TemplateInstanceEvent)*} handlers) {
	shared void eventHandler(TemplateInstanceEvent event) {
		for (handler in handlers) {
			handler(event);
		}
	}	
}

class NodeWrapper(node) {
	shared dynamic node;
}

class NodeProcessor(originalNode,clonedNode) {
	variable dynamic originalNode;
	variable dynamic clonedNode;

	shared NodeWrapper findNode(Linker<Nothing> linker) {
		dynamic {
			while (exists originalCurrent = originalNode, exists clonedCurrent = clonedNode) {
				if (originalCurrent.nodeType == 3 && originalCurrent.data == "") {
					log("Linker context found empty text node in original... | context: ``this.string`` linker: ``linker.string``");
				}
				if (linker.node === originalCurrent) {
					return NodeWrapper(clonedCurrent);
				}
				
				if (exists tmp = originalCurrent.firstChild) {
					originalNode = tmp;
					clonedNode = clonedCurrent.firstChild;
				} else if (exists tmp = originalCurrent.nextSibling) {
					originalNode = tmp;
					clonedNode = clonedCurrent.nextSibling;
				} else {
					variable dynamic originalNext = null;
					variable dynamic originalParent = originalCurrent.parentNode;
					variable dynamic clonedNext = null;
					variable dynamic clonedParent = clonedCurrent.parentNode;
					
					while (originalNext is Null) {
						if (exists originalTmp = originalParent, exists clonedTmp = clonedParent) {
							originalNext = originalTmp.nextSibling;
							originalParent = originalTmp.parentNode;
							
							clonedNext = clonedTmp.nextSibling;
							clonedParent = clonedTmp.parentNode;
							
						} else {
							throw Exception("Linker context did not find node for linker!!! | context: ``this.string`` linker: ``linker.string``");
						}
					}
					
					originalNode = originalNext;
					clonedNode = clonedNext;
				}
				// Make sure originalNode and clonedNode are the same (if not the cloning have not worked as expected, empty text nodes?)
				compare(originalNode, clonedNode);
			}
			throw Exception("Linker context did not find node for linker!!! | context: ``this.string`` linker: ``linker.string``");
		}
		
	}
	void compare(dynamic original, dynamic clone) {
		dynamic {
			if (exists original, exists clone) {
				if (original.nodeType != clone.nodeType) {
					log("Original and clone nodeType do not match:  " + original.nodeType + "/" + clone.nodeType);
					//throw Exception("Original and clone nodeType do not match:  " + original.nodeType + "/" + clone.nodeType);
				}
			} else {
				if (exists original) {
					log("Original exsists but no clone node, orignal:  " + original);
					//throw Exception("Original exsists but no clone node, orignal:  " + original);
				} else if (exists clone) {
					log("Unexpected clone node (original do not exsist), clone: " + clone);
					//throw Exception("Unexpected clone node (original do not exsist), clone: " + clone);
				}
			}
		}
	}

}

shared interface StdTemplateInstantiationContext satisfies TemplateInstantiationContext {
	shared formal EventHandlers getEventHandlers();
}

class StdTemplateInstantiationContextImpl(parentLookup, nodeProcessor) satisfies StdTemplateInstantiationContext {
	BindingLookup parentLookup;
	NodeProcessor nodeProcessor;

	EventHandlerRegistry eventHandlerRegistry = EventHandlerRegistry();
 
	shared actual BindingContext bindingContext = ChildBindingContext(parentLookup, eventHandlerRegistry.registerEventHandler);
	
	
	shared actual EventHandlers getEventHandlers() => eventHandlerRegistry.createEventHandlers();
	
	shared actual void invoke<in Input>(Linker<Input> linker, Input model) given Input satisfies Value {
		NodeWrapper warapper = nodeProcessor.findNode(linker);
		dynamic {
			linker.instantiate(this, warapper.node, model);
		}
	}

	shared actual Result bind<in Input, out Result>(Input input, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		return bindingContext.bind(input, binding);
	}
	
	shared actual void registerEventHandler(Anything(TemplateInstanceEvent) eventHandler, Set<TemplateInstanceEvent> events) => eventHandlerRegistry.registerEventHandler(eventHandler, events);
}
shared StdTemplateInstantiationContext createTemplateInstantiationContext(BindingLookup parentLookup, dynamic originalNode, dynamic clonedNode) {
	dynamic {
		return StdTemplateInstantiationContextImpl(parentLookup, NodeProcessor(originalNode, clonedNode));
	}
}

class StdTemplateDuplicationContextImpl(nodeProcessor) satisfies TemplateDuplicationContext {
	NodeProcessor nodeProcessor;

	shared actual Linker<Input> invoke<Input>(Linker<Input> linker) given Input satisfies Value<Anything,Nothing> {
		NodeWrapper warapper = nodeProcessor.findNode(linker);
		dynamic {
			return linker.duplicate(this, warapper.node);
		}
	}
}
shared TemplateDuplicationContext createTemplateDuplicationContext(dynamic originalNode, dynamic clonedNode) {
	dynamic {
		return StdTemplateDuplicationContextImpl(NodeProcessor(originalNode, clonedNode));
	}
}
