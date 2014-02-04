import eu.arvidson.ceylon.jsinterop.native { log, now }
import eu.arvidson.ceylon.jsinterop { JsMapWrapper }

class LCSRepeatEntry(init, index, removalFlag, node, eventHandlers) {
	shared variable Boolean init;
	shared variable Integer index;
	shared variable Boolean removalFlag;
	shared dynamic node;
	shared EventHandlers eventHandlers;
	
	shared void triggerEvent(TemplateInstanceEvent event) {
		eventHandlers.triggerEvent(event);
	}
}

class LCSNode<Type>(previous, index, obj, chain, length, weight) {
	shared LCSNode<Type>? previous;
	shared Integer index;
	shared Type obj;
	
	shared LCSNode<Type>? chain;
	shared Integer length;
	shared Integer weight;
	
	shared void addTo(SequenceBuilder<Type> builder) {
		if (exists chain = chain) {
			chain.addTo(builder);
		}
		builder.append(obj);
	}
	shared LCSNode<Type>? findLongestChain(Integer index) {
		if (this.index < index) {
			// Part of chain, do we abort search or continue?
			if (exists previous, length * 2 - 1 < this.index) {
				if (exists tmp = previous.findLongestChain(index)) {
					if (tmp.length > length) {
						return tmp;
					} else if (tmp.length == length) {
						if (tmp.weight + (tmp.index + 1 == index then 1 else 0) > weight + (this.index + 1 == index then 1 else 0)) {
							return tmp;
						}
					}
				}
			}
			return this;
		} else if (exists previous) {
			return previous.findLongestChain(index);
		} else {
			return null;
		}
	}
}
class LCSState<Type>() {
	shared variable LCSNode<Type>? last = null;
	shared variable LCSNode<Type>? longest = null;
	shared variable Integer index = 1;
	
	shared LCSNode<Type>? findLongestChain(Integer index) {
		// TODO check if we can use longest
		if (exists last = last) {
			return last.findLongestChain(index);	
		} else {
			return null;
		}
		
	}
	shared {Type*} buildIterable() {
		if (exists tmp = longest) {
			value builder = SequenceBuilder<Type>();
			tmp.addTo(builder);
			return builder.sequence;
		} else {
			return empty;
		}
	}
}
class LCSRepeatController<in Input, OutputGet, in Type>(bindingLookup, container, template, argumentValue, output, input) given Input satisfies Value given OutputGet satisfies Identifiable {
	BindingLookup bindingLookup;
	dynamic container;
	Template<Input,Type> template;
	Value<{OutputGet*},Nothing> argumentValue;
	OutputBinding<Input,Value<OutputGet,Nothing>> output;
	Input input;

	JsMapWrapper<OutputGet,LCSRepeatEntry> map = JsMapWrapper<OutputGet,LCSRepeatEntry>();
	variable Boolean removalFlag = false;
	
	shared void eventHandler(TemplateInstanceEvent event) {
		if (event == initializeEvent) {
			
		} else {
			map.eachEntry((OutputGet key, LCSRepeatEntry item) => item.triggerEvent(event));
		}
		if (event == disposeEvent) {
			map.clear();
		}
	}
	
	shared void update({OutputGet*} sequence) {
		removalFlag = !removalFlag;
		if (map.empty) {
			log("Repeat has no current content, just add the new sequence");
			Integer start = now();
			variable Integer index = 1;
			for (obj in sequence) {
				dynamic {
					value eventHandlerRegistry = EventHandlerRegistry();
					value outputValue = ConstantValue<OutputGet>(obj);

					value lookup = SimpleBindingLookup(output, outputValue, bindingLookup, bindingLookup.updateModel, bindingLookup.updateView);
					value newInstance = template.instantiate(TemplateInstanceContext(lookup, eventHandlerRegistry.registerEventHandler), input);

					dynamic item = document.createElement("repeatitem");
					item.appendChild(newInstance.node);
					value lcsEntry = LCSRepeatEntry(false, index++, removalFlag, item, eventHandlerRegistry.createEventHandlers());
					//               map.put(obj, LCSRepeatEntry(false, index++, removalFlag, item, newInstance.eventHandler));
					if (exists tmp = map.put(obj, lcsEntry)) {
						throw Exception("Same object more than once in iterable not permitted: ``obj.string``");
					}
					container.appendChild(item);
					lcsEntry.triggerEvent(initializeEvent);
				}
			}
			Integer end = now();
			log("Total: " + (end - start).string);
		} else if (sequence.empty) {
			log("Repeat with empty new sequence, clear all content");
			Integer start = now();
			dynamic {
				map.eachEntry((OutputGet key, LCSRepeatEntry item) => item.triggerEvent(disposeEvent));
				while (container.hasChildNodes()) {
					dynamic firstChild = container.firstChild;
					if (exists firstChild) {
						container.removeChild(firstChild);
					}
				}
			}
			map.clear();
			Integer end = now();
			log("Total: " + (end - start).string);
		} else {
			log("Repeat updated with LCS alg");
			Integer start = now();
			value state = LCSState<OutputGet>();
			for (obj in sequence) {
				variable Integer y1 = now();
				LCSRepeatEntry? entry = map.get(obj);
				if (exists entry) {
					// TODO check that removal flag has not already been set indicating same obj more than once
					//if (removalFlag == entry.removalFlag) {
					//	throw Exception("Same object more than once in iterable not permitted: ``obj.string``");
					//}

					value chain = state.findLongestChain(entry.index);
					Integer length; 
					Integer weight;
					if (exists chain) {
						length = chain.length + 1;
						weight = chain.weight + (entry.index == chain.index + 1 then 1 else 0);
					} else {
						length = 1;
						weight = 0;
					}
					value node = LCSNode(state.last, entry.index, obj, chain, length, weight);
					if (exists tmp = state.longest) {
						if (node.length > tmp.length || (node.length == tmp.length && node.weight > tmp.length)) {
							state.longest = node;
						}
					} else {
						state.longest = node;
					}
					state.last = node;
					
					variable Integer y2;
					// Update entry 
					y2 = now();
					entry.index = state.index++;
					entry.removalFlag = removalFlag;
					variable Integer y3 = now();
					
				} else {
					// Obj is new, create entry in new map for it
					dynamic {
						value eventHandlerRegistry = EventHandlerRegistry();
						value outputValue = ConstantValue<OutputGet>(obj);
						value lookup = SimpleBindingLookup(output, outputValue, bindingLookup, bindingLookup.updateModel, bindingLookup.updateView);
						value newInstance = template.instantiate(TemplateInstanceContext(lookup, eventHandlerRegistry.registerEventHandler), input);
						dynamic item = document.createElement("repeatitem");
						item.appendChild(newInstance.node);
						if (exists tmp = map.put(obj, LCSRepeatEntry(true, state.index++, removalFlag, item, eventHandlerRegistry.createEventHandlers()))) {
							throw Exception("Same object more than once in iterable not permitted: ``obj.string``");
						}
					}
					
				}
			}

			value lcsIter = state.buildIterable().iterator();

			Integer t1 = now();
			// Remove old unused instance
			log("Entries in map before remove: ``map.size``");
			map.eachEntry((OutputGet key, LCSRepeatEntry item) {
				if (item.removalFlag != removalFlag) {
					item.triggerEvent(disposeEvent);
					dynamic {
						container.removeChild(item.node);
					}
					map.remove(key);
				}
				return null;
			});

			log("Entries in map after remove: ``map.size``");
			Integer t2 = now();
			
			variable [OutputGet, LCSRepeatEntry]? currentLcsEntry = nextLcsEntry(lcsIter);
			for (obj in sequence) {
				LCSRepeatEntry? entry = map.get(obj);
				assert(exists entry);
				
				if (exists lcsEntry = currentLcsEntry) {
					if (obj == lcsEntry[0]) {
						// Skipp as obj is already on page at this post
						currentLcsEntry = nextLcsEntry(lcsIter);
					} else {
						// Insert/Move to before lcs.first
						dynamic {
							container.insertBefore(entry.node, lcsEntry[1].node);
							if (entry.init) {
								entry.triggerEvent(initializeEvent);
								entry.init = false;
							}
						}
					}
				} else {
					// Empty lcs, insert last (append child)
					dynamic {
						container.appendChild(entry.node);
						if (entry.init) {
							entry.triggerEvent(initializeEvent);
						}
					}				
				}
			}
			
			
			Integer end = now();
			log("Total: " + (end - start).string);
			log("Calc: " + (t1 - start).string);
			log("Delete: " + (t2 - t1).string);
			log("Insert: " + (end - t2).string);

		}
	}
	[OutputGet, LCSRepeatEntry]? nextLcsEntry(Iterator<OutputGet> iter) {
		value next = iter.next();
		if (is OutputGet next) {
			value entry = map.get(next);
			assert(exists entry);
			return [next, entry];
		} else {
			return null;
		}
	}

}


class RepeatLinker<in Input, out OutputGet, in Type>(node, template, argument, output) satisfies Linker<Input> given Input satisfies Value given OutputGet satisfies Identifiable {
	shared actual dynamic node;
	Template<Input,Type> template;
	Binding<Input,Value<{OutputGet*},Nothing>> argument;
	OutputBinding<Input,Value<OutputGet,Nothing>> output;
	
	shared actual void instantiate(TemplateInstantiationContext ctx, dynamic node, Input input) {
		LCSRepeatController<Input,OutputGet,Type> controller;
		value argumentValue = ctx.bind(input, argument);
		dynamic {
			controller = LCSRepeatController(ctx.bindingContext.getLookup(), node, template, argumentValue, output, input);
		}
		observe(argumentValue, controller.update, ctx.registerEventHandler);
		ctx.registerEventHandler(controller.eventHandler, allEventsSet);
	}
	
	shared actual Linker<Input> duplicate(TemplateDuplicationContext ctx, dynamic node) {
		dynamic {
			return RepeatLinker(node, template, argument, output);
		}
	}
}

shared alias RepeatContent<in Input,Type> given Input satisfies Value => FragmentContent<Input,Type>; // {String|OptionalStringBinding<InputGet,InputSet,Nothing>|Component<InputGet,InputSet>+}
shared class Repeat<in Input, out OutputGet,Type>(argument, output, {RepeatContent<Input,Type>+} content) satisfies Component<Input,Type> given Input satisfies Value given OutputGet satisfies Identifiable {
	Binding<Input,Value<{OutputGet*},Nothing>> argument;
	OutputBinding<Input,Value<OutputGet,Nothing>> output;

	shared actual Template<Input,Type> build() {
		dynamic {
			//dynamic element = document.createElement("div");
			dynamic element = document.createElement("repeatcontainer");
			return Template<Input,Type>(element, RepeatLinker(element, Fragment(content).build(), argument, output));
		}
	}
	
}



// --------------------
