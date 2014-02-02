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

shared alias EventHandlerFunction => Anything(TemplateInstanceEvent);
shared alias RegisterEventHandlerFunction => Anything(EventHandlerFunction, Set<TemplateInstanceEvent>);

shared interface EventHandlerEntry {
	shared formal void appendToSequenceBuilders(SequenceBuilder<EventHandlerFunction> initialize, SequenceBuilder<EventHandlerFunction> dispose, SequenceBuilder<EventHandlerFunction> updateView, SequenceBuilder<EventHandlerFunction> updateModel);
}

class SimpleEventHandlerEntry(prev, handler, events) satisfies EventHandlerEntry {
	EventHandlerEntry prev;
	EventHandlerFunction handler;
	Set<TemplateInstanceEvent> events;

	shared actual void appendToSequenceBuilders(SequenceBuilder<EventHandlerFunction> initialize, SequenceBuilder<EventHandlerFunction> dispose, SequenceBuilder<EventHandlerFunction> updateView, SequenceBuilder<EventHandlerFunction> updateModel) {
		if (initializeEvent in events) {
			initialize.append(handler);
		}
		if (disposeEvent in events) {
			dispose.append(handler);
		}
		if (updateViewEvent in events) {
			updateView.append(handler);
		}
		if (updateModelEvent in events) {
			updateModel.append(handler);
		}
		prev.appendToSequenceBuilders(initialize, dispose, updateView, updateModel);
	}
}
class CollectionEventHandlerEntry(prev, collection) satisfies EventHandlerEntry {
	EventHandlerEntry prev;
	EventHandlerEntry collection;

	shared actual void appendToSequenceBuilders(SequenceBuilder<EventHandlerFunction> initialize, SequenceBuilder<EventHandlerFunction> dispose, SequenceBuilder<EventHandlerFunction> updateView, SequenceBuilder<EventHandlerFunction> updateModel) {
		collection.appendToSequenceBuilders(initialize, dispose, updateView, updateModel);
		prev.appendToSequenceBuilders(initialize, dispose, updateView, updateModel);
	}
}

shared object emptyEventHandlerEntry satisfies EventHandlerEntry {
	shared actual void appendToSequenceBuilders(SequenceBuilder<EventHandlerFunction> initialize, SequenceBuilder<EventHandlerFunction> dispose, SequenceBuilder<EventHandlerFunction> updateView, SequenceBuilder<EventHandlerFunction> updateModel) {}
}

shared class EventHandlerRegistry() {
	variable EventHandlerEntry last = emptyEventHandlerEntry;

	shared void registerEventHandler(EventHandlerFunction eventHandler, Set<TemplateInstanceEvent> events) {
		last = SimpleEventHandlerEntry(last, eventHandler, events);
	}
	shared void addEntry(EventHandlerEntry entry) {
		last = CollectionEventHandlerEntry(last, entry);
	}

	shared EventHandlerEntry getEntry() {
		return last;
	}
}
shared class EventHandlerCollection() {
}

EventHandlers createEventHandlers(EventHandlerEntry entry) {
	value initialize = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value dispose = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value updateView = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	value updateModel = SequenceBuilder<Anything(TemplateInstanceEvent)>();
	
	entry.appendToSequenceBuilders(initialize, dispose, updateView, updateModel);
	return EventHandlers(initialize.sequence.reversed, dispose.sequence.reversed, updateView.sequence.reversed, updateModel.sequence.reversed);
}

shared class EventHandlers(initializeHandlers, disposeHandlers, updateViewHandlers, updateModelHandlers) {
	{Anything(TemplateInstanceEvent)*} initializeHandlers;
	{Anything(TemplateInstanceEvent)*} disposeHandlers;
	{Anything(TemplateInstanceEvent)*} updateViewHandlers;
	{Anything(TemplateInstanceEvent)*} updateModelHandlers;
	
	{Anything(TemplateInstanceEvent)*} getEventHandlers(TemplateInstanceEvent event) {
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
