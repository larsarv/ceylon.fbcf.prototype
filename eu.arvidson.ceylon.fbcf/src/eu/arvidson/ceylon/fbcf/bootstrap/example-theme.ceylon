import eu.arvidson.ceylon.fbcf.base { TemplateInstanceContext, simpleROValue, initializeAndAppendToBody, Value, Template, roroot, Fragment }
import eu.arvidson.ceylon.fbcf.html5 { HtmlFlow }
class Theme() {
	Template<Value<Object, Nothing>,HtmlFlow> buildTemplate() {
		value app = roroot<Object>();
		return Fragment<Value<Object, Nothing>,HtmlFlow> {
			navbar { }
		}.build();		
	}
	shared void run() {
		initializeAndAppendToBody((TemplateInstanceContext context) {
			return buildTemplate().instantiate(context, simpleROValue(1));
		});
	}

}


shared void startTheme() {
	Theme().run();
}
