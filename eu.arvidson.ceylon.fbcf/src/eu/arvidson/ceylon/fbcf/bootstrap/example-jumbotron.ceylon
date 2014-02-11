import eu.arvidson.ceylon.fbcf.base { TemplateInstanceContext, simpleROValue, initializeAndAppendToBody, Value, Template, roroot, Fragment }
import eu.arvidson.ceylon.fbcf.html5 { HtmlFlow, li, attrClass, div, attrRole, h1, p, a, attrHref, attrType, HtmlLi, h2, hr, footer }
class Jumbotron() {
	Template<Value<Object, Nothing>,HtmlFlow> buildTemplate() {
		value app = roroot<Object>();
		return Fragment<Value<Object, Nothing>,HtmlFlow> {
			navbar {
				type = navbarInverse;
				fixedTop =  true;
				header = "Project name";
				items = [];
			},			
			
			container {
				jumbotron { 
					title = "Hello, world!"; 
					content = [
						p { "This is a template for a simple marketing or informational website. It 
						     includes a large callout called a jumbotron and three supporting pieces of content. Use it as a starting point to create something more unique."
						},
						p { linkButton("Learn more »", null, buttonSizeLarge, buttonTypePrimary) }
					]; 
				}
			},
			container {
				row {
					column(deviceTypeMedium, 4, {
						h2 { "Heading" },
						p { "Donec id elit non mi porta gravida at eget metus. 
						     Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. 
						     Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui." },
						p { linkButton("View details »", "#", buttonSizeStandard, buttonTypeDefault)}
					}),
					column(deviceTypeMedium, 4, {
						h2 { "Heading" },
						p { "Donec id elit non mi porta gravida at eget metus. 
						     Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. 
						     Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui." },
						p { linkButton("View details »", "#", buttonSizeStandard, buttonTypeDefault)}
					}),
					column(deviceTypeMedium, 4, {
						h2 { "Heading" },
						p { "Donec id elit non mi porta gravida at eget metus. 
						     Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. 
						     Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui." },
						p { linkButton("View details »", "#", buttonSizeStandard, buttonTypeDefault)}
					})
				},
				hr {  },
				footer { p { "© Company 2014" } }
			}
		}.build();		
	}
	shared void run() {
		initializeAndAppendToBody((TemplateInstanceContext context) {
			return buildTemplate().instantiate(context, simpleROValue(1));
		});
	}

}


shared void startJumbotron() {
	Jumbotron().run();
}
