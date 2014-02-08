import ceylon.language.meta.model { Attribute, CeylonValue=Value, Method, Function }
import ceylon.collection { LinkedList }
import eu.arvidson.ceylon.jsinterop.native { log, now }
import eu.arvidson.ceylon.jsinterop { JsMapWrapper }

shared alias Unsubscribe => Anything();
 
shared interface Value<out Get=Anything, in Set=Nothing> {
	shared formal Get get();
	shared formal void set(Set newValue);
	doc("Returns a unsbscibe funtion if value can be updated, if value is constant it returns null")
	shared formal Unsubscribe? observ(Anything(Get) observer);
}
shared alias RWValue<Type> => Value<Type, Type>;

shared interface BindingLookup {
	shared formal Result? lookup<Input,Result>(Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value;

	shared formal void updateModel();
	shared formal void updateView();
}
shared interface BindingContext {
	shared formal void registerEventHandler(Anything(TemplateInstanceEvent) handler, Set<TemplateInstanceEvent> events);
	shared formal Result bind<Input,Result>(Input input, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value;
	shared formal BindingLookup getLookup();
}


shared interface Binding<in Input,out Result> given Input satisfies Value given Result satisfies Value {
	shared formal Result bind(BindingContext ctx, Input input);
}
shared alias ReadOnlyBinding<Input,Type> given Input satisfies Value => Binding<Input, Value<Type,Nothing>>;

shared alias ConstantOrBinding<Input,Type> given Input satisfies Value => Type|ReadOnlyBinding<Input, Type>;

shared void observe<in Model>(Value<Model,Nothing> val, Anything(Model) observer, RegisterEventHandlerFunction registerEventHandler) {
	value unsub = val.observ(observer);
	if (exists unsub) {
		registerEventHandler(disposeEventHandler(unsub), disposeEvent.asSet());
	}
}
void disposeEventHandler(Anything() unsub)(TemplateInstanceEvent event) {
	unsub();
}

abstract class Uninitialized() of uninitialized {}
object uninitialized extends Uninitialized() {}

shared variable Integer baseValueCounterUpdateView = 0;
shared variable Integer baseValueCounterInitialize = 0;
shared variable Integer baseValueCounterDispose = 0;
shared variable Integer baseValueCounterActive = 0;

abstract class BaseValue<out GetType, in SetType>() satisfies Value<GetType, SetType> {
	variable GetType|Uninitialized currentValue = uninitialized;
//	variable {Anything(GetType)*} observers = empty;
	variable LinkedList<Anything(GetType)> observers = LinkedList<Anything(GetType)>();
	variable {Unsubscribe*} unsubs = empty;
	
	baseValueCounterActive += 1;

	shared actual Unsubscribe observ(Anything(GetType) observer) {
		observers.add(observer);
		return unsubscribe(observer);
	}
	
	void unsubscribe(Anything(GetType) observer)() {
		observers.removeElement(observer);
	}

	void invokeObservers() {
		if (is GetType tmp = currentValue) {
			for (observer in observers) {
				observer(tmp);
			} 
		}
	}		
	
	shared default void handleUpdateViewEvent(TemplateInstanceEvent event) {
		baseValueCounterUpdateView += 1;
		GetType newValue = get();
		if (observers.empty) {
			currentValue = newValue;
		} else {
			if (is Identifiable tmp1 = currentValue, is Identifiable tmp2 = newValue) {
				if (!(tmp1 === tmp2)) {
					currentValue = newValue;
					invokeObservers();
				}
			} else if (is Object tmp1 = currentValue, is Object tmp2 = newValue) {
				if (tmp1 != tmp2) {
					currentValue = newValue;
					invokeObservers();
				}
			} else if (currentValue is Null && newValue is Null) {
				// Current and new value are both null, do nothing
			} else {
				currentValue = newValue;
				invokeObservers();
			}
		}
	}
	// TODO Remove this and make sure observers get() initial value when they are created?
	shared void handleInitializeEvent(TemplateInstanceEvent event) {
		baseValueCounterInitialize += 1;
		currentValue = get();
		invokeObservers();
	}
	shared void handleDisposeViewEvent(TemplateInstanceEvent event) {
		baseValueCounterDispose += 1;
		baseValueCounterActive -= 1;
		for (unsub in unsubs) {
			unsub();
		}
		observers.clear();
	}

	shared void init(Anything(Anything(TemplateInstanceEvent),Set<TemplateInstanceEvent>) registerEventHandler, Boolean forceHandlerUpdate, <Unsubscribe?>* unsubs) {
		this.unsubs = unsubs.coalesced;
		registerEventHandler(handleDisposeViewEvent, disposeEvent.asSet());
		// Only register updateView and initialize eventhandlers if we are subscibing to changes (or forceHandlerUpdate == true), if we are not subscibing to changes we asume
		if (forceHandlerUpdate || !this.unsubs.empty) {
			registerEventHandler(handleUpdateViewEvent, updateViewEvent.asSet());
			registerEventHandler(handleInitializeEvent, initializeEvent.asSet());
		}
	}
}

class SimpleValue<out GetType,in SetType>(val) extends BaseValue<GetType, SetType>() given SetType satisfies GetType {
	variable GetType val;

	shared actual GetType get() => val;
	
	shared actual void set(SetType newValue) {
		val = newValue;
	}
	
}
class ConstantValue<Get>(val) satisfies Value<Get,Nothing> {
	variable Get val;
	
	shared actual Get get() => val;

	// TODO Remove observer(val) and make sure observers get() initial value when they are created?
	shared actual Unsubscribe? observ(Anything(Get) observer) {
		observer(val);
		return null;
	}
	shared actual void set(Nothing newValue) {}
}

class PassthroughBinding<Result>() satisfies Binding<Result,Result> given Result satisfies Value {
	shared actual Result bind(BindingContext ctx, Result input) => input;
}

class ChainedBinding<Input,Intermediate,Result>(first,last) satisfies Binding<Input,Result> given Input satisfies Value given Intermediate satisfies Value given Result satisfies Value {
	Binding<Input,Intermediate> first;
	Binding<Intermediate,Result> last;

	shared actual Result bind(BindingContext ctx, Input input) {
		Intermediate intermediate = ctx.bind(input, first);
		return ctx.bind(intermediate, last);
	}

}

class CeylonAttributeValue<in Container, out Get, in Set>(attribute, Container container) extends BaseValue<Get, Set>() {
	Attribute<Container,Get,Set> attribute;
	variable CeylonValue<Get,Set> val = attribute(container);
	shared actual Get get() {
/*
		value result = val.get();
		if (exists result) {
			log("CeylonAttributeValue.get ``result.string`` for ``attribute.string``");
		} else {
			log("CeylonAttributeValue.get <null> for ``attribute.string``");
		}
		return result;
*/
		return val.get();
	}
	shared actual void set(Set newValue) {
		val.set(newValue);
	}
	
	shared void rebind(Container container) {
		val = attribute(container);
	}
}

class CeylonAttributeBinding<Input,Container,Get,Set>(attribute) satisfies Binding<Input,Value<Get,Set>> given Input satisfies Value<Container,Nothing> {
	Attribute<Container,Get,Set> attribute;
	
	shared actual Value<Get,Set> bind(BindingContext ctx, Input input) {
		value result = CeylonAttributeValue(attribute, input.get());
		result.init(ctx.registerEventHandler, true, input.observ(result.rebind));
		return result;
	}
	
}

class GetterFunctionValue<in Container, out Get>(getter, container) extends BaseValue<Get,Nothing>() {
	Get(Container) getter;
	variable Container container;
	
	shared actual Get get() => getter(container);
	shared actual void set(Nothing newValue) {
		throw Exception("It should not have been possible to call this function as Set=Nothing");
	}

	shared void rebind(Container container) {
		this.container = container;
	}
	
}

class GetterFunctionBinding<Input, in Container, Get>(getter) satisfies Binding<Input,Value<Get,Nothing>> given Input satisfies Value<Container,Nothing> {
	Get(Container) getter;
	
	shared actual Value<Get,Nothing> bind(BindingContext ctx, Input input) {
		value result = GetterFunctionValue(getter, input.get());
		result.init(ctx.registerEventHandler, true, input.observ(result.rebind));
		return result;
	}

	

	
}

class MethodValue<in Container, out Get>(method, container) extends BaseValue<Get,Nothing>() {
	Method<Container,Get,[]> method;
	variable Container container;
	
	shared actual Get get() => method(container)();
	shared actual void set(Nothing newValue) {
		throw Exception("It should not have been possible to call this function as Set=Nothing");
	}
	
	shared void rebind(Container container) {
		this.container = container;
	}
	
}

class MethodBinding<Input, in Container, Get>(method) satisfies Binding<Input,Value<Get,Nothing>> given Input satisfies Value<Container,Nothing> {
	Method<Container,Get,[]> method;
	
	shared actual Value<Get,Nothing> bind(BindingContext ctx, Input input) {
		value result = MethodValue(method, input.get());
		result.init(ctx.registerEventHandler, true, input.observ(result.rebind));
		return result;
	}
	
	
}

shared alias GetterOrSetter<in Container, out Get=Anything,in Set=Nothing> => Getter<Get,Container>|Setter<Set,Container>;
shared alias Getter<out Type,in Container> => Type(Container)|Attribute<Container,Type,Nothing>;
shared alias Setter<in Type, in Container> => Anything(Type)(Container)|Attribute<Container,Anything,Type>;

shared alias OptionalStringBinding<in Input, in Set> given Input satisfies Value => Binding<Input,Value<String?,Set>>;

shared Binding<Value<Container,Nothing>,Value<Get,Set>> bindToAttr<in Container, out Get=Anything, in Set=Nothing>(Attribute<Container,Get,Set> target) => CeylonAttributeBinding<Value<Container,Nothing>,Container,Get,Set>(target);
shared Binding<Value<Container,Nothing>,Value<Get,Nothing>> bindToFun<in Container, out Get=Anything>(Get(Container) target) => GetterFunctionBinding<Value<Container,Nothing>,Container,Get>(target);
shared Binding<Value<Container,Nothing>,Value<Get,Nothing>> bindToMethod<in Container, out Get=Anything>(Method<Container,Get,[]> target) => MethodBinding<Value<Container,Nothing>,Container,Get>(target);


shared class OutputBinding<in Input, out Result>() satisfies Binding<Input,Result> given Input satisfies Value given Result satisfies Value {
	shared actual Result bind(BindingContext ctx, Input input) {
		throw Exception("Should never be called, binding should be registered in binding context with a value.");
	}
}

class RootBinding<Input>() satisfies Binding<Input,Input> given Input satisfies Value {
	shared actual Input bind(BindingContext ctx, Input input) {
		return input;
	}
}

/*
shared Binding<Value<Get,Set>,Value<Get,Set>> model<Get,Set=Nothing>() {
	return NopBinding<Value<Get,Set>>();
}
shared Binding<Tuple<Anything, Type, Anything[]>, Nothing, Type, Nothing> first<Type>() {
	return GetterFunctionBinding((Tuple<Anything, Type, Anything[]> model) => model[0]);
}
shared Binding<Tuple<Anything, Anything, Tuple<Anything, Type, Anything[]>>, Nothing, Type, Nothing> second<Type>() {
	return GetterFunctionBinding((Tuple<Anything, Anything, Tuple<Anything, Type, Anything[]>> model) => model[1]);
}
*/

shared Value<GetType,SetType> simpleValue<out GetType,in SetType>(GetType val, RegisterEventHandlerFunction registerEventHadler) given SetType satisfies GetType {
	value result = SimpleValue<GetType,SetType>(val);
	result.init(registerEventHadler, true);
	return result;
}

shared Value<Type,Nothing> simpleROValue<out Type>(Type val) {
	return ConstantValue<Type>(val);
}
shared Value<Type,Type> simpleRWValue<Type>(Type val, RegisterEventHandlerFunction registerEventHadler) {
	value result = SimpleValue<Type,Type>(val);
	result.init(registerEventHadler, true);
	return result;
}


class ChildBindingLookup(map, parent, updateModel, updateView) satisfies BindingLookup {
	JsMapWrapper<Object, Value<Anything,Nothing>> map;
	BindingLookup parent;

	shared actual Result? lookup<Input,Result>(Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		value val = map.get(binding) else parent.lookup(binding);
		assert(is Result? val);
		return val;
	}

	shared actual void updateModel();
	shared actual void updateView();
}
shared class ChildBindingContext(BindingLookup parent, registerEventHandler) satisfies BindingContext {
	value map = JsMapWrapper<Object, Value<Anything,Nothing>>();
	ChildBindingLookup lookup = ChildBindingLookup(map, parent, parent.updateModel, parent.updateView);

	shared actual BindingLookup getLookup() => lookup;

	shared actual void registerEventHandler(Anything(TemplateInstanceEvent) handler, Set<TemplateInstanceEvent> events);
	
	shared actual Result bind<Input,Result>(Input input, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		return lookup.lookup(binding) else addBinding(input, binding);
	}

	Result addBinding<Input,Result>(Input input, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		Result val = binding.bind(this, input);
		map.put(binding, val);
		return val;
	}
	shared void registerBinding<Input,Result>(Result val, Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		map.put(binding, val);
	}

}
class SimpleBindingLookup<Input, Result>(binding, val, parent, updateModel, updateView) satisfies BindingLookup given Input satisfies Value given Result satisfies Value {
	OutputBinding<Input, Result> binding;
	Result val;
	BindingLookup parent;

	shared actual Result? lookup<Input,Result>(Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		if (this.binding == binding) {
			assert(is Result? val);
			return val;
		} else {
			return parent.lookup(binding);
		}
	}
	
	shared actual void updateModel();
	shared actual void updateView();
}

shared class RootBindingLookup() satisfies BindingLookup {
	shared variable EventHandlers? eventHandlers = null;
	shared actual Result? lookup<Input,Result>(Binding<Input,Result> binding) given Input satisfies Value given Result satisfies Value {
		return null;
	}

	shared actual void updateModel() {
		log("Start updateModel()");
		Integer start = now();
		if (exists eventHandlers = eventHandlers) {
			eventHandlers.triggerEvent(updateModelEvent);
		}
		Integer end = now();
		log("End updateModel() ``end - start``ms");
	}
	
	shared actual void updateView() {
		baseValueCounterDispose = 0;
		baseValueCounterInitialize = 0;
		baseValueCounterUpdateView = 0;

		log("Start updateView()");
		Integer start = now();
		if (exists eventHandlers = eventHandlers) {
			eventHandlers.triggerEvent(updateViewEvent);
		}
		Integer end = now();
		log("End updateView() ``end - start``ms");
		log("BaseValue events, dispose: ``baseValueCounterDispose`` initialize: ``baseValueCounterInitialize`` updateView: ``baseValueCounterUpdateView`` active: ``baseValueCounterActive``");
	}
}


shared interface TupleValue<out Args> satisfies Value<Args, Nothing> given Args satisfies Anything[] {
	shared formal Result invoke<Result>(Function<Result,Args> fun); 
}

// TODO Remove?? Do we need TupleBinding??
shared interface TupleBinding<in Input,out Args> satisfies Binding<Input, TupleValue<Args>> given Args satisfies Anything[] given Input satisfies Value {
	shared actual formal TupleValue<Args> bind(BindingContext ctx, Input input);
}

object emptyTupleValue satisfies TupleValue<[]> {
	shared actual [] get() {
		return [];
	}
	shared actual Result invoke<Result>(Function<Result,[]> fn) {
		return fn();
	}

	shared actual Unsubscribe? observ(Anything([]) observer) => null;
	
	shared actual void set(Nothing newValue) {}
	
}

shared object emptyTuple satisfies TupleBinding<Value<Anything,Nothing>,[]> {
	
	shared actual TupleValue<[]> bind(BindingContext ctx, Value<Anything,Nothing> input) {
		return emptyTupleValue;
	}
	
}
shared TupleBinding<Value<Anything,Nothing>,[]> noargs = emptyTuple;

class TupleValue1<Arg1>(args) extends BaseValue<[Arg1], Nothing>() satisfies TupleValue<[Arg1]> {
	variable [Arg1] args;

	shared actual [Arg1] get() {
		return args;
	}
	shared actual Result invoke<Result>(Function<Result,[Arg1]> fn) {
		return fn(*args);
	}

	shared actual void set(Nothing newValue) {}
	
	shared void updateArg1(Arg1 arg1) {
		args = [arg1];
	}

}

shared class Tuple1<Input, out Arg1>(arg1) satisfies TupleBinding<Input,[Arg1]> given Input satisfies Value {
	Binding<Input,Value<Arg1,Nothing>> arg1;
	
	shared actual TupleValue<[Arg1]> bind(BindingContext ctx, Input input) {
		value val1 = ctx.bind(input, arg1); 
		value result = TupleValue1([val1.get()]);
		result.init(ctx.registerEventHandler, false, val1.observ(result.updateArg1));
		return result;
	}
	
}

class TupleValue2<Arg1,Arg2>(args) extends BaseValue<[Arg1,Arg2], Nothing>() satisfies TupleValue<[Arg1,Arg2]> {
	variable [Arg1,Arg2] args;

	shared actual [Arg1,Arg2] get() {
		return args;
	}
	shared actual Result invoke<Result>(Function<Result,[Arg1,Arg2]> fn) {
		return fn(*args);
	}

	shared actual void set(Nothing newValue) {}

	shared void updateArg1(Arg1 arg1) {
		args = [arg1, args[1]];
	}

	shared void updateArg2(Arg2 arg2) {
		args = [args[0], arg2];
	}
	
}

shared class Tuple2<Input, out Arg1, out Arg2>(arg1, arg2) satisfies TupleBinding<Input,[Arg1,Arg2]> given Input satisfies Value {
	Binding<Input,Value<Arg1,Nothing>> arg1;
	Binding<Input,Value<Arg2,Nothing>> arg2;

	shared actual TupleValue<[Arg1,Arg2]> bind(BindingContext ctx, Input input) {
		value val1 = ctx.bind(input, arg1); 
		value val2 = ctx.bind(input, arg2);
		value result = TupleValue2([val1.get(),val2.get()]);
		result.init(ctx.registerEventHandler, false, val1.observ(result.updateArg1),val2.observ(result.updateArg2));
		return result;
	}
	
}

class MethodCallValue<Container,out Get,Arguments>(Container container,method,arguments,invoker) extends BaseValue<Get, Nothing>() given Arguments satisfies Anything[] {
	Method<Container,Get,Arguments> method; 
	variable Arguments arguments;
	variable Function<Get,Arguments> fun = method(container);
	Get(Function<Get,Arguments>) invoker; // TODO Remove when compiler bug is fixed and this is not needed...

	shared actual Get get() {
//		return fun(*arguments); TODO FIX when compiler bug is fixed
		return invoker(fun);
	}
	shared actual void set(Nothing newValue) {}

	shared void updateContainer(Container container) {
		fun = method(container);
	}
	shared void updateArguments(Arguments arguments) {
		this.arguments = arguments;
	}
}

class MethodCallBinding<in Input, out ResultGet, out ContainerGet,Arguments>(container, method, args) satisfies Binding<Input, Value<ResultGet, Nothing>> given Input satisfies Value given Arguments satisfies Anything[] {
	Binding<Input, Value<ContainerGet,Nothing>> container;
	Method<ContainerGet,ResultGet,Arguments> method; 
	TupleBinding<Input,Arguments> args;

	shared actual Value<ResultGet,Nothing> bind(BindingContext ctx, Input input) {
		value containerValue = ctx.bind(input, container);
		value argumentsValue = ctx.bind(input, args);

		value result = MethodCallValue(
			containerValue.get(),
			method,
			argumentsValue.get(),
			argumentsValue.invoke<ResultGet>
		);
		result.init(ctx.registerEventHandler, true, containerValue.observ(result.updateContainer), argumentsValue.observ(result.updateArguments));
		return result;
	}
}

shared Binding<Input,Value<ResultGet,Nothing>> methodCall<in Input,out ContainerGet,ResultGet,Arguments=Nothing>(
	Binding<Input, Value<ContainerGet,Nothing>> container,
	Method<ContainerGet,ResultGet,Arguments> method, 
	TupleBinding<Input,Arguments> args) 
		given Input satisfies Value given Arguments satisfies Anything[] {
	return MethodCallBinding(container,method, args);
}

class CallableMethodValue<Container,out Get,Arguments>(Container container,method,arguments,invoker) extends BaseValue<Get(), Nothing>() given Arguments satisfies Anything[] {
	Method<Container,Get,Arguments> method; 
	variable Arguments arguments;
	variable Function<Get,Arguments> fun = method(container);
	Get(Function<Get,Arguments>) invoker; // TODO Remove when compiler bug is fixed and this is not needed...

	shared actual Get() get() {
		return invoke;
	}
	shared actual void set(Nothing newValue) {}
	
	shared void updateContainer(Container container) {
		fun = method(container);
	}

	shared void updateArguments(Arguments arguments) {
		this.arguments = arguments;
	}

	Get invoke() {
		//return fun(*arguments); //TODO FIX when compiler bug is fixed
		return invoker(fun);
	}
}

class CallableMethodBinding<in Input, out ResultGet, out ContainerGet,Arguments>(container, method, args, autoUpdate = true) satisfies Binding<Input, Value<ResultGet(), Nothing>> given Input satisfies Value given Arguments satisfies Anything[] {
	Binding<Input, Value<ContainerGet,Nothing>> container;
	Method<ContainerGet,ResultGet,Arguments> method; 
	TupleBinding<Input,Arguments> args;
	Boolean autoUpdate;
	
	shared actual Value<ResultGet(),Nothing> bind(BindingContext ctx, Input input) {
		value containerValue = ctx.bind(input, container);
		value argumentsValue = ctx.bind(input, args);

		value result = CallableMethodValue(
			containerValue.get(),
			method,
			argumentsValue.get(),
			argumentsValue.invoke<ResultGet>
		);

		result.init(ctx.registerEventHandler, false, containerValue.observ(result.updateContainer), argumentsValue.observ(result.updateArguments));
		return result;
	}
}

/*
class UpdateModelValue(Anything() updateModel) satisfies Value<Anything(), Nothing> {

	shared actual Anything() get() => updateModel;
	
	shared actual Unsubscribe observ(Anything(Anything()) observer) => () { return null; };
	
	shared actual void set(Nothing newValue) {}
	
	
}
class UpdateModelBinding<in Input>() satisfies Binding<Input, Value<Anything(), Nothing>> given Input satisfies Value {

	shared actual Value<Anything(),Nothing> bind(BindingContext ctx, Input input) => UpdateModelValue(ctx.getLookup().updateModel);
	
	
}
*/

void dummy() {}

class NopValue() satisfies Value<Anything(), Nothing> {
	
	shared actual Anything() get() => dummy;
	
	shared actual Unsubscribe? observ(Anything(Anything()) observer) => null;
	
	shared actual void set(Nothing newValue) {}
}
class NopBinding<in Input>() satisfies Binding<Input, Value<Anything(), Nothing>> given Input satisfies Value {
	shared actual Value<Anything(),Nothing> bind(BindingContext ctx, Input input) => NopValue();
}

String? oldbuildStringList(Array<Boolean> flags, List<String> strings) {
	value sb = StringBuilder();
	variable Integer i = 0;
	for (str in strings) {
		if (flags[i] else false) {
			if (i > 0) {
				sb.append(" ");
			}
			sb.append(str);
		}
		i += 1;
	}
	if (sb.size == 0) {
		return null;
	} else {
		return sb.string;
	}
/*
	value result = " ".join(flags.indexed.filter((Integer->Boolean elem) => elem.item).map((Integer->Boolean elem) => strings[elem.key]).coalesced);
	if (result.empty) {
		return null;
	} else {
		return result;
	}
*/
}


String? buildStringFromList(String separator, {String?*} strings) {
	value result = separator.join(strings.coalesced);
	if (result.empty) {
		return null;
	} else {
		return result;
	}
/*
	variable Boolean first = true;
	value sb = StringBuilder();
	for (str in strings) {
		if (exists str) {
			if (first) {
				first = false;
				sb.append(separator);
			}
			sb.append(str);
		}
	}
	if (first) {
		return null;
	} else {
		return sb.string;
	}
*/
}

class StringsValue(separator, strings) extends BaseValue<String?, Nothing>() {
	String separator;
	Array<String?> strings;
	
	variable Uninitialized|String? val = buildStringFromList(separator, strings);
	
	shared actual String? get() {
		if (is Uninitialized tmp = val) {
			val = buildStringFromList(separator, strings);
		}
		assert(is String? tmp = val);
		return tmp;
	}
	
	shared actual void set(Nothing newValue) {}
	
	shared void update(Integer index)(String? tmp) {
		val = uninitialized;
		strings.set(index, tmp);
	}
}

class StringsBinding<in Input>(separator, args) satisfies Binding<Input,Value<String?,Nothing>> given Input satisfies Value {
	String separator;
	{Binding<Input,Value<String?,Nothing>>*} args;
	
	shared actual Value<String?,Nothing> bind(BindingContext ctx, Input input) {
		value values = SequenceBuilder<Value<String?,Nothing>>();
		value unsubs =  SequenceBuilder<Anything()?>();
		
		for (arg in args) {
			value val = arg.bind(ctx, input); 
			values.append(val);
		}
		
		value result = StringsValue(separator, Array(values.sequence.map((Value<String?,Nothing> elem) => elem.get())));
		
		variable Integer index = 0;
		for (val in values.sequence) {
			unsubs.append(val.observ(result.update(index++)));
		}
		
		result.init(ctx.registerEventHandler, false, *unsubs.sequence);
		return result;
	}
}
shared Binding<Input,Value<String?,Nothing>> stringList<in Input>({Binding<Input,Value<String?,Nothing>>|String*} args) given Input satisfies Value {
	value tmp = args.map((Binding<Input,Value<String?,Nothing>>|String elem) {
		switch (elem)
		case (is String) {
			return const(elem);
		}
		case (is Binding<Input,Value<String?,Nothing>>) {
			return elem;
		}
	});
	return StringsBinding(" ", tmp);
}

shared Binding<Input,Value<String?,Nothing>> string<in Input>({Binding<Input,Value<String?,Nothing>>|String*} args) given Input satisfies Value {
	value tmp = args.map((Binding<Input,Value<String?,Nothing>>|String elem) {
		switch (elem)
		case (is String) {
			return const(elem);
		}
		case (is Binding<Input,Value<String?,Nothing>>) {
			return elem;
		}
	});
	return StringsBinding("", tmp);
}

class ConditionalValue<GetType,SetType>(condition, thenResult, thenSetter, elseResult, elseSetter) extends BaseValue<GetType, SetType>() {
	variable Boolean condition;
	variable GetType thenResult;
	variable GetType elseResult;
	
	void thenSetter(SetType val);
	void elseSetter(SetType val);
	
	shared actual GetType get() {
		if (condition) {
			return thenResult;
		} else  {
			return elseResult;
		}
	}
	
	shared actual void set(SetType newValue) {
		if (condition) {
			thenSetter(newValue);
		} else  {
			elseSetter(newValue);
		}
		
	}
	
	shared void updateCondition(Boolean val) {
		condition = val;
	}
	shared void updateThen(GetType val) {
		thenResult = val;
	}
	shared void updateElse(GetType val) {
		elseResult = val;
	}
}

class ConditionalBinding<in Input, out ResultGetType, in ResultSetType>(condition, thenResult, elseResult) satisfies Binding<Input,Value<ResultGetType,ResultSetType>> given Input satisfies Value {
	Binding<Input,Value<Boolean,Nothing>> condition;
	Binding<Input,Value<ResultGetType,ResultSetType>> thenResult;
	Binding<Input,Value<ResultGetType,ResultSetType>> elseResult;

	shared actual Value<ResultGetType,ResultSetType> bind(BindingContext ctx, Input input) {
		value condValue = condition.bind(ctx, input);
		value thenValue = thenResult.bind(ctx, input);
		value elseValue = elseResult.bind(ctx, input);

		ConditionalValue<ResultGetType,ResultSetType> result = ConditionalValue(condValue.get(), thenValue.get(), thenValue.set, elseValue.get(), elseValue.set);
		result.init(ctx.registerEventHandler, false, condValue.observ(result.updateCondition), thenValue.observ(result.updateThen), elseValue.observ(result.updateElse));
		return result;
	}
}

shared Binding<Input, Value<ResultGetType, ResultSetType>> conditional<in Input, out ResultGetType, in ResultSetType>(Binding<Input,Value<Boolean,Nothing>> condition, Binding<Input,Value<ResultGetType,ResultSetType>> thenResult, Binding<Input,Value<ResultGetType,ResultSetType>> elseResult) given Input satisfies Value 
	=> ConditionalBinding(condition, thenResult, elseResult);


shared class BindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet>(binding) {
	shared default Binding<Value<InputGet,InputSet>,Value<CurrentGet,CurrentSet>> binding;

	shared BindingBuilder<InputGet,InputSet,ResultGet,ResultSet> chain<ResultGet,ResultSet>(Binding<Value<CurrentGet,CurrentSet>,Value<ResultGet,ResultSet>> target) => BindingBuilder(ChainedBinding(binding, target));
	shared BindingBuilder<InputGet,InputSet,ResultGet,ResultSet> attr<ResultGet,ResultSet>(Attribute<CurrentGet,ResultGet,ResultSet> target) => chain(bindToAttr(target));
	shared BindingBuilder<InputGet,InputSet,ResultGet,Nothing> fun<ResultGet>(ResultGet(CurrentGet) target) => chain(bindToFun(target));
	shared BindingBuilder<InputGet,InputSet,ResultGet,Nothing> method<ResultGet>(Method<CurrentGet,ResultGet,[]> target) => chain(bindToMethod(target));

	shared BindingBuilder<InputGet,InputSet,ResultGet,Nothing> methodWithArgs<ResultGet,Arguments>(Method<CurrentGet,ResultGet,Arguments> method, TupleBinding<Value<InputGet, InputSet>,Arguments> args) given Arguments satisfies Anything[] => BindingBuilder(MethodCallBinding(binding, method, args));
	shared BindingBuilder<InputGet,InputSet,ResultGet(),Nothing> callableMethod<ResultGet,Arguments>(Method<CurrentGet,ResultGet,Arguments> method, TupleBinding<Value<InputGet, InputSet>,Arguments> args) given Arguments satisfies Anything[] => BindingBuilder(CallableMethodBinding(binding, method, args));

	shared BindingBuilder<InputGet,InputSet,ResultGet,Nothing> conditional<ResultGet,Type>(Type const, ResultGet thenResult, ResultGet elseResult) {
		 return fun((CurrentGet val) {
		 	if (is Object const, is Object val, const == val) {
		 		return thenResult;
		 	} else {
		 		return elseResult;
		 	}
		 });
	}
}

shared class OutputBindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet>(binding) extends BindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet>(binding) {
	shared actual OutputBinding<Value<InputGet,InputSet>,Value<CurrentGet,CurrentSet>> binding;
}

shared class RootBindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet>(binding) extends BindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet>(binding) {
	Binding<Value<InputGet,InputSet>,Value<CurrentGet,CurrentSet>> binding;

	shared OutputBindingBuilder<InputGet,InputSet,Type,Type> rwroot<Type>() => OutputBindingBuilder(OutputBinding<Value<InputGet,InputSet>, Value<Type,Type>>());
	shared OutputBindingBuilder<InputGet,InputSet,Type,Nothing> roroot<Type>() => OutputBindingBuilder(OutputBinding<Value<InputGet,InputSet>, Value<Type,Nothing>>());
	shared BindingBuilder<InputGet,InputSet,Anything(),Nothing> nop() => BindingBuilder(NopBinding<Value<InputGet, InputSet>>());

	// TODO FIX??? Better name for next method??
	shared BindingBuilder<InputGet,InputSet,Type,Nothing> constOrBinding<Type>(ConstantOrBinding<Value<InputGet,InputSet>, Type> arg) {
		if (is Binding<Value<InputGet,InputSet>,Value<Type,Nothing>> arg) {
			return BindingBuilder(arg);
		}
		assert(is Type arg);
		return BindingBuilder(const<Value<InputGet,InputSet>,Type>(arg));
	}
}

shared BindingBuilder<InputGet,InputSet,CurrentGet,CurrentSet> builder<InputGet,InputSet,CurrentGet,CurrentSet>(Binding<Value<InputGet,InputSet>,Value<CurrentGet,CurrentSet>> binding)
		=> BindingBuilder(binding);

shared RootBindingBuilder<InputGet,InputSet,InputGet,InputSet> rootBuilder<InputGet,InputSet>() {
	return RootBindingBuilder(RootBinding<Value<InputGet,InputSet>>());
}

shared RootBindingBuilder<Type,Nothing,Type,Nothing> roroot<Type>() {
	return RootBindingBuilder(RootBinding<Value<Type,Nothing>>());
}
shared RootBindingBuilder<Type,Type,Type,Type> rwroot<Type>() {
	return RootBindingBuilder(RootBinding<Value<Type,Type>>());
}

class ConstBinding<in Input,out Type>(Type const) satisfies Binding<Input, Value<Type,Nothing>> given Input satisfies Value {

	shared actual Value<Type,Nothing> bind(BindingContext ctx, Input input) => ConstantValue(const);
	

}
shared Binding<Input, Value<Type,Nothing>> const<in Input, out Type>(Type const) given Input satisfies Value => ConstBinding(const);
