import eu.arvidson.ceylon.fbcf.base { TemplateInstanceContext, simpleROValue, initializeAndAppendToBody, Value, Template, roroot, Fragment, Component }
import eu.arvidson.ceylon.fbcf.html5 { HtmlFlow, li, attrClass, div, attrRole, h1, p, a, attrHref, attrType }
class Theme() {
	Component<Input,HtmlFlow> buttonExamples<in Input>(ButtonSize size) given Input satisfies Value {
		return p { 
			button("Default", size, buttonTypeDefault), " ",
			button("Primary", size, buttonTypePrimary), " ",
			button("Success", size, buttonTypeSuccess), " ",
			button("Info", size, buttonTypeInfo), " ",
			button("Warning", size, buttonTypeWarning), " ",
			button("Danger", size, buttonTypeDanger), " ",
			button("Link", size, buttonTypeLink)
		};
	}
	
	Template<Value<Object, Nothing>,HtmlFlow> buildTemplate() {
		value app = roroot<Object>();
		return Fragment<Value<Object, Nothing>,HtmlFlow> {
			navbar { 
				header = "Bootstrap theme";
				items = [
					navbarItem("", "Home", true),
					navbarItem("abount", "About"),
					navbarItem("contact", "Contact"),
					navbarDropdown { 
						header = "Dropdown";
						items = [
							navbarItem("", "Action"),
							navbarItem("", "Another action"),
							navbarItem("", "Something else here"),
							navbarDropdownDivider(), 
							navbarDropdownHeader("Nav header"), 
							navbarItem("", "Separated link"),
							navbarItem("", "One more separated link")
						];
					}
				];
			},			
			div {
				attrClass("container theme-showcase"),
				attrRole("main"),
				jumbotron { 
					title = "Hello, world!"; 
					content = [
						p { "This is a template for a simple marketing or informational website. 
						     It includes a large callout called a jumbotron and three supporting pieces of content. 
						     Use it as a starting point to create something more unique." },
						p { a { attrHref("#"), attrClass("btn btn-primary btn-lg"), attrRole("button"), "Learn more »" } }
					]; 
				},
				pageHeader("Buttons"),
				buttonExamples(buttonSizeLarge),
				buttonExamples(buttonSizeStandard),
				buttonExamples(buttonSizeSmall),
				buttonExamples(buttonSizeExtraSmall),
				pageHeader("Thumbnails"),
				pageHeader("Dropdown menus"),
				pageHeader("Navbars"),
				pageHeader("Alerts"),
				pageHeader("Progress bars"),
				pageHeader("List groups"),
				pageHeader("Panels"),
				pageHeader("Wells")
			}
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
