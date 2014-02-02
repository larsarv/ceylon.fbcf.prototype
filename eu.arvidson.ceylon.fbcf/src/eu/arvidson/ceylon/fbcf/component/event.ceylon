import ceylon.collection { HashSet }
import eu.arvidson.ceylon.util { SingletonSet }

shared abstract class TemplateInstanceEvent() of initializeEvent | disposeEvent | updateViewEvent | updateModelEvent {
	shared formal Set<TemplateInstanceEvent> asSet();
}
shared object initializeEvent extends TemplateInstanceEvent() {
	shared actual Set<TemplateInstanceEvent> asSet() => initializeEventSet;
}
shared object disposeEvent extends TemplateInstanceEvent() {
	shared actual Set<TemplateInstanceEvent> asSet() => disposeEventSet;
}
shared object updateViewEvent extends TemplateInstanceEvent() {
	shared actual Set<TemplateInstanceEvent> asSet() => updateViewEventSet;
}
shared object updateModelEvent extends TemplateInstanceEvent() {
	shared actual Set<TemplateInstanceEvent> asSet() => updateModelEventSet;
}

Set<TemplateInstanceEvent> initializeEventSet = SingletonSet(initializeEvent);
Set<TemplateInstanceEvent> disposeEventSet = SingletonSet(disposeEvent);
Set<TemplateInstanceEvent> updateViewEventSet = SingletonSet(updateViewEvent);
Set<TemplateInstanceEvent> updateModelEventSet = SingletonSet(updateModelEvent);


shared Set<TemplateInstanceEvent> allEventsSet = HashSet({initializeEvent,disposeEvent,updateViewEvent,updateModelEvent});

shared alias RegisterEventHandlerFunction => Anything(Anything(TemplateInstanceEvent), Set<TemplateInstanceEvent>);

shared class EventHandlerRegistry() {
	value initializeHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value disposeHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value updateViewHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value updateModelHandlers = SequenceBuilder<Anything(TemplateInstanceEvent)>();

	shared void registerEventHandler(Anything(TemplateInstanceEvent) eventHandler, Set<TemplateInstanceEvent> events) {
		for (event in events) {
			switch (event)
			case (initializeEvent) {
				initializeHandlers.append(eventHandler);
			}
			case (disposeEvent) {
				disposeHandlers.append(eventHandler);
			}
			case (updateViewEvent) {
				updateViewHandlers.append(eventHandler);
			}
			case (updateModelEvent) {
				updateModelHandlers.append(eventHandler);
			}				
		}
	}
	shared void includeEventHandlers(EventHandlers eventHandlers) {
		initializeHandlers.appendAll(eventHandlers.getEventHandlers(initializeEvent));
		disposeHandlers.appendAll(eventHandlers.getEventHandlers(disposeEvent));
		updateViewHandlers.appendAll(eventHandlers.getEventHandlers(updateViewEvent));
		updateModelHandlers.appendAll(eventHandlers.getEventHandlers(updateModelEvent));
	}

	shared EventHandlers createEventHandlers() {
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
