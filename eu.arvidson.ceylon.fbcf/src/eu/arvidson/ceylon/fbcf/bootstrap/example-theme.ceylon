import eu.arvidson.ceylon.fbcf.base { TemplateInstanceContext, simpleROValue, initializeAndAppendToBody, Value, Template, roroot, Fragment, Component }
import eu.arvidson.ceylon.fbcf.html5 { HtmlFlow, li, attrClass, div, attrRole, h1, p, a, attrHref, attrType, HtmlLi }
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
	{Component<Value<Object, Nothing>,HtmlLi>*} menuItems = [
		menuItem("", "Home", true),
		menuItem("abount", "About"),
		menuItem("contact", "Contact"),
		menuDropdown { 
			header = "Dropdown";
			items = [
			menuItem("", "Action"),
			menuItem("", "Another action"),
			menuItem("", "Something else here"),
			menuDropdownDivider(), 
			menuDropdownHeader("Nav header"), 
			menuItem("", "Separated link"),
			menuItem("", "One more separated link")
			];
		}
	];
	Template<Value<Object, Nothing>,HtmlFlow> buildTemplate() {
		value app = roroot<Object>();
		return Fragment<Value<Object, Nothing>,HtmlFlow> {
			navbar {
				type = navbarInverse;
				fixedTop =  true;
				header = "Bootstrap theme";
				items = [*menuItems];
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
				thumbnail("holder.js", 200, 200, "A generic square placeholder image with a white border around it, making it resemble a photograph taken with an old instant camera"),
				pageHeader("Dropdown menus"),
				dropdown { 
					header = "Dropdown";
					items = [
						menuItem("", "Action", true),
						menuItem("", "Another action"),
						menuItem("", "Something else here"),
						menuDropdownDivider(),
						menuItem("", "Separated link")
					];
				},
				pageHeader("Navbars"),
				navbar {
					type = navbarStandard;
					fixedTop =  false;
					header = "Project Name";
					items = [*menuItems];
				},			
				navbar {
					type = navbarInverse;
					fixedTop =  false;
					header = "Project Name";
					items = [*menuItems];
				},			
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