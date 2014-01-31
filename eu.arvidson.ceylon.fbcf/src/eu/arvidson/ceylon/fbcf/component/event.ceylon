import eu.arvidson.ceylon.fbcf.native { now }
shared abstract class TemplateInstanceEvent() of initializeEvent | disposeEvent | updateViewEvent | updateModelEvent {
	shared Set<TemplateInstanceEvent> asSet() => LazySet({this});
}
shared object initializeEvent extends TemplateInstanceEvent() {}
shared object disposeEvent extends TemplateInstanceEvent() {}
shared object updateViewEvent extends TemplateInstanceEvent() {}
shared object updateModelEvent extends TemplateInstanceEvent() {}

shared Set<TemplateInstanceEvent> allEventsSet = LazySet({initializeEvent,disposeEvent,updateViewEvent,updateModelEvent});

shared alias RegisterEventHandlerFunction => Anything(Anything(TemplateInstanceEvent), Set<TemplateInstanceEvent>);

shared class EventHandlerRegistry() {
	value handlers = SequenceBuilder<[Anything(TemplateInstanceEvent),Set<TemplateInstanceEvent>]>();

	shared void registerEventHandler(Anything(TemplateInstanceEvent) eventHandler, Set<TemplateInstanceEvent> events) {
		// Handlers will be placed in seqence in reverse order it was registered (last registerd will be first) 
		handlers.append([eventHandler,events]);
	}
	shared void includeEventHandlers(EventHandlers eventHandlers) {
		for (event in {initializeEvent, disposeEvent, updateViewEvent, updateModelEvent}) {
			value set = LazySet({event});
			{Anything(TemplateInstanceEvent)*} handlers = eventHandlers.getEventHandlers(event);
			for (handler in handlers) {
				this.handlers.append([handler,set]);
			}
		}
	}

	shared EventHandlers createEventHandlers() {
		value initializeHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
		value disposeHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
		value updateViewHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
		value updateModelHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();

		for (entry in handlers.sequence) {
			value handler = entry[0];
			value events = entry[1];
			for (event in events) {
				switch (event)
				case (initializeEvent) {
					initializeHandlers.append(handler);
				}
				case (disposeEvent) {
					disposeHandlers.append(handler);
				}
				case (updateViewEvent) {
					updateViewHandlers.append(handler);
				}
				case (updateModelEvent) {
					updateModelHandlers.append(handler);
				}				
			}
		}
		return EventHandlers(initializeHandlers.sequence, disposeHandlers.sequence, updateViewHandlers.sequence, updateModelHandlers.sequence);
	}
}

shared class EventHandlers(initializeHandlers, disposeHandlers, updateViewHandlers, updateModelHandlers) {
	{Anything(TemplateInstanceEvent)*} initializeHandlers;
	{Anything(TemplateInstanceEvent)*} disposeHandlers;
	{Anything(TemplateInstanceEvent)*} updateViewHandlers;
	{Anything(TemplateInstanceEvent)*} updateModelHandlers;
	
	shared {Anything(TemplateInstanceEvent)*} getEventHandlers(TemplateInstanceEvent event) {
		switch (event)
		case (initializeEvent) {
			return initializeHandlers;
		}
		case (disposeEvent) {
			return disposeHandlers;
		}
		case (updateViewEvent) {
			return updateViewHandlers;
		}
		case (updateModelEvent) {
			return updateModelHandlers;
		}
	}
	
	shared void triggerEvent(TemplateInstanceEvent event) {
		value handlers = getEventHandlers(event);
		for (handler in handlers) {
			handler(event);
		}
	}
	
} 
