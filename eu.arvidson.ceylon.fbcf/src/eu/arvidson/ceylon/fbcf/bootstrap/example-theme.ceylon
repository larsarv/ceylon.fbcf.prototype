import eu.arvidson.ceylon.fbcf.base { TemplateInstanceContext, simpleROValue, initializeAndAppendToBody, Value, Template, roroot, Fragment, Component, const }
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
					header = "Project name";
					items = [*menuItems];
				},			
				navbar {
					type = navbarInverse;
					fixedTop =  false;
					header = "Project name";
					items = [*menuItems];
				},			
				pageHeader("Alerts"),
				alert(alertTypeSuccess, "Well done!", "You successfully read this important alert message."),
				alert(alertTypeInfo, "Heads up!", "This alert needs your attention, but it's not super important."),
				alert(alertTypeWarning, "Warning!", "Best check yo self, you're not looking too good."),
				alert(alertTypeDanger, "Oh snap!", "Change a few things up and try submitting again."),
				pageHeader("Progress bars"),
				simpleProgress(progressTypeStandard, 60, "60% Complete"),
				simpleProgress(progressTypeSuccess, 40, "40% Complete (success)"),
				simpleProgress(progressTypeInfo, 20, "20% Complete"),
				simpleProgress(progressTypeWarning, 60, "60% Complete (warning)"),
				simpleProgress(progressTypeDanger, 80, "80% Complete (danger)"),
				progress {
					progressBar(progressTypeSuccess, 35, "35% Complete (success)"),
					progressBar(progressTypeWarning, 20, "20% Complete (warning)"),
					progressBar(progressTypeDanger, 10, "10% Complete (danger)")					
				},
				pageHeader("List groups"),
				row {
					column(deviceTypeSmall, 4, {
						listGroup {
							listGroupItem(false, null, "Cras justo odio"),
							listGroupItem(false, null, "Dapibus ac facilisis in"),
							listGroupItem(false, null, "Morbi leo risus"),
							listGroupItem(false, null, "Porta ac consectetur ac"),
							listGroupItem(false, null, "Vestibulum at eros")
						}
					}),
					column(deviceTypeSmall, 4, {
						linkListGroup {
							linkListGroupItem("#", true, null, "Cras justo odio"),
							linkListGroupItem("#", false, null, "Dapibus ac facilisis in"),
							linkListGroupItem("#", false, null, "Morbi leo risus"),
							linkListGroupItem("#", false, null, "Porta ac consectetur ac"),
							linkListGroupItem("#", false, null, "Vestibulum at eros")
						}
					}),
					column(deviceTypeSmall, 4, {
						linkListGroup {
							linkListGroupItem("#", true, "List group item heading", "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit."),
							linkListGroupItem("#", false, "List group item heading", "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit."),
							linkListGroupItem("#", false, "List group item heading", "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.")
						}
					})
				},
				pageHeader("Panels"),
				row {
					column(deviceTypeSmall, 4, {
						panel(panelTypeDefault, "Panel title", {"Panel content"}),
						panel(panelTypePrimary, "Panel title", {"Panel content"})
					}),
					column(deviceTypeSmall, 4, {
						panel(panelTypeSuccess, "Panel title", {"Panel content"}),
						panel(panelTypeInfo, "Panel title", {"Panel content"})
					}),
					column(deviceTypeSmall, 4, {
						panel(panelTypeWarning, "Panel title", {"Panel content"}),
						panel(panelTypeDanger, "Panel title", {"Panel content"})
					})
				},
				pageHeader("Wells"),
				well { p { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. 
				            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. 
				            Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. 
				            Aenean lacinia bibendum nulla sed consectetur." } }
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
