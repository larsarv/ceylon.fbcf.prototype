import eu.arvidson.ceylon.jsinterop.native { log }

shared void initializeAndAppendToBody(TemplateInstance(TemplateInstanceContext) instantiator) {
	Integer start = system.milliseconds;
	value eventHandlerReistry = EventHandlerRegistry();
	value rootBindingLookup = RootBindingLookup();
	
	value instance = instantiator(TemplateInstanceContext(rootBindingLookup, eventHandlerReistry.registerEventHandler));
	
	EventHandlers eventHandlers = eventHandlerReistry.createEventHandlers();
	rootBindingLookup.eventHandlers = eventHandlers; 
	dynamic {
		dynamic element = document.body;
		element.appendChild(instance.node);
	}
	eventHandlers.triggerEvent(initializeEvent);
	Integer end = system.milliseconds;
	log("initializeAndAppendToBody: ``end - start``ms");
}

