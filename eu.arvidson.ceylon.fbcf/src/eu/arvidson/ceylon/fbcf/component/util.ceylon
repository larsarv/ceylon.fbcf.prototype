import eu.arvidson.ceylon.fbcf.native { log }

shared void initializeAndAppendToBody(TemplateInstance(BindingLookup,EventHandlerRegistry) instantiator) {
	Integer start = system.milliseconds;
	value eventHandlerReistry = EventHandlerRegistry();
	value rootBindingLookup = RootBindingLookup();
	
	value instance = instantiator(rootBindingLookup, eventHandlerReistry);
	eventHandlerReistry.addEntry(instance.eventHandlerEntry);
	
	EventHandlers eventHandlers = createEventHandlers(eventHandlerReistry.getEntry());
	rootBindingLookup.eventHandlers = eventHandlers; 
	dynamic {
		dynamic element = document.body;
		element.appendChild(instance.node);
	}
	eventHandlers.triggerEvent(initializeEvent);
	Integer end = system.milliseconds;
	log("initializeAndAppendToBody: ``end - start``ms");
}

