import eu.arvidson.ceylon.fbcf.native { log, now }
import eu.arvidson.ceylon.fbcf.component { RWValue, Repeat, Value, Template, Event, ShowIfExists, EventHandler, rwroot, Text, simpleRWValue, BindingLookup, EventHandlerRegistry, initializeAndAppendToBody }
import eu.arvidson.ceylon.fbcf.component.html5 { div, br, button, h1, h2, span, input, attrType, propValue }


variable Integer nextTestDataItemId = 0;

shared class TestData(title, items) {
	shared variable String title;
	shared variable {TestDataItem*} items;
	shared variable String? addCount = "1";
	
	Integer addCountAsInteger() {
		if (exists tmp = addCount) {
			Integer count = parseInteger(tmp) else 1;
			return count > 100 then 100 else count;
			//			return parseInteger(tmp.filter((Character elem) => elem.digit).string) else 1;
		} 
		return 1;
	}
	shared void addItems() {
		items = { for (Integer index in (addCountAsInteger()..1)) TestDataItem(nextTestDataItemId++, "new one")  }.sequence.reversed.chain(items);
	}
}
shared class TestDataItem(id, message) {
	shared variable Integer id;
	shared variable String message;
}

void toggle(RWValue<TestData?> val) {
	if (exists tmp = val.get()) {
		val.set(null);
	} else {
		val.set(TestData("Template Testing", { for (Integer index in (100..0)) TestDataItem(nextTestDataItemId++, "sadf")  }.sequence.reversed));
	}
}
void reset(RWValue<TestData> val) {
	value data = TestData("Template reset", { for (Integer index in (100..0)) TestDataItem(nextTestDataItemId++, "sadf")  }.sequence.reversed);
	val.set(data);
}

Template<Value<TestData?,TestData?>,Anything> buildTemplate() {
	value optModel = rwroot<TestData?>();
	value appModel = optModel.rwroot<TestData>();
	value item = optModel.roroot<TestDataItem>();
	
	value component = div {
		button { "Toggle", EventHandler(optModel.binding, "click", (RWValue<TestData?> data, Event even) => toggle(data)) },
		ShowIfExists { 
			argument = optModel.binding; 
			output = appModel.binding;
			h1 { appModel.attr(`TestData.title`).binding, " test2" },
			input { attrType("text"), propValue(appModel.attr(`TestData.addCount`).binding) }, //, onKeyup(optModel.updateModel().binding) },
			button { "Add", EventHandler(appModel.binding, "click", (Value<TestData> appModel, Event even) => appModel.get().addItems()) },
			button { "Del all", EventHandler(appModel.attr(`TestData.items`).binding, "click", (RWValue<{TestDataItem*}> appModel, Event even) => appModel.set(empty) ) }, 
			button { "Reset", EventHandler(appModel.binding, "click", (RWValue<TestData> data, Event even) => reset(data)) },
			button { "Set to 10", EventHandler(appModel.binding, "click", (Value<TestData> appModel, Event even) => appModel.get().addCount = "10" ) }, br(),
			appModel.attr(`TestData.addCount`).binding, br(),
			Text(appModel.attr(`TestData.items`).attr(`Iterable<Anything>.size`).binding), br(),
			
			Repeat { 
				argument = appModel.attr(`TestData.items`).binding;
				output = item.binding;
				h2 { "Item #", Text(item.fun(TestDataItem.id).binding), ": " , item.fun(TestDataItem.message).binding },
				div {
					span {"test1", " ", "test"}, " ",
					span {"test", " ", "test"}, " ",
					span {"test", " ", "test"}, " ",
					span {"test", " ", "test"}, " ",
					span {"test", " ", "test"}
				},
				div {"End of Item #", Text(item.fun(TestDataItem.id).binding) }
			},
			
			div { "test1" }
		},
		div { "test555" }
	};
	
	
	return component.build();
}

shared void testClick() {
	value template = buildTemplate();
	
	initializeAndAppendToBody((BindingLookup bindingLookup, EventHandlerRegistry eventHandlerRegistry) {
		return template.instantiate(bindingLookup, simpleRWValue<TestData?>(null, eventHandlerRegistry.registerEventHandler));
	});
	
}
