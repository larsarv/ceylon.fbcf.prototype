import eu.arvidson.ceylon.fbcf.html5 { nav, attrRole, HtmlFlow, attrClass, div, button_=button, attrType, attrData, span, a, b, attrHref, ul, li, HtmlLi, CommonContent, SimpleContent, h1, HtmlPhrasing }
import eu.arvidson.ceylon.fbcf.base { Component, Value }

String? valIfTrue(Boolean flag, String val) {
	if (flag) {
		return val;
	} else {
		return null;
	}
}

Component<Input,HtmlFlow> navbar<in Input>(String header, Component<Input,HtmlLi> *items) given Input satisfies Value {
	return nav<Input> {
		attrClass("navbar navbar-inverse navbar-fixed-top"), 
		attrRole("navigation"),
		div {
			attrClass("container"),
			div { 
				attrClass("navbar-header"),
				button_ { 
					attrType("button"),
					attrClass("navbar-toggle"),
					attrData("toggle", "collapse"),
					attrData("target", ".navbar-collapse"),
					span { attrClass("sr-only"), "Toggle navigation" },
					span { attrClass("icon-bar") },
					span { attrClass("icon-bar") },
					span { attrClass("icon-bar") }
				},
				a { attrClass("navbar-brand"), attrHref("#"), header }
			},
			div {
				attrClass("navbar-collapse collapse"),
				ul {
					attrClass("nav navbar-nav"),
					*items
				}
			}
		}
	};
}

shared Component<Input,HtmlLi> navbarItem<in Input>(String href, String header, Boolean active = false) given Input satisfies Value => 
		li<Input> { attrClass(valIfTrue(active, "active")), a { attrHref("#``href``"), header }};

shared Component<Input,HtmlLi> navbarDropdown<in Input>(String header, Component<Input,HtmlLi> *items) given Input satisfies Value {
	return li<Input> { 
		attrClass("nav navbar-nav"), 
		a { attrHref("#"), attrClass("dropdown-toggle"), attrData("toggle", "dropdown"), header ," ", b { attrClass("caret") }},
		ul {
			attrClass("dropdown-menu"),
			*items
		}
	};
}
shared Component<Input,HtmlLi> navbarDropdownDivider<in Input>() given Input satisfies Value => 
		li { attrClass("divider") };
shared Component<Input,HtmlLi> navbarDropdownHeader<in Input>(String text) given Input satisfies Value => 
		li { attrClass("dropdown-header"), text };

shared Component<Input,HtmlFlow> jumbotron<in Input>(String title, SimpleContent<Input, HtmlFlow>* content) given Input satisfies Value => 
		div { attrClass("jumbotron"), h1 { title }, *content };

shared Component<Input,HtmlFlow> pageHeader<in Input>(String title) given Input satisfies Value =>
		div { attrClass("page-header"), h1 { title } };

shared abstract class ButtonSize(shared String clazz) of buttonSizeLarge|buttonSizeStandard|buttonSizeSmall|buttonSizeExtraSmall {}
shared object buttonSizeLarge extends ButtonSize("btn-lg") {}
shared object buttonSizeStandard extends ButtonSize("") {}
shared object buttonSizeSmall extends ButtonSize("btn-sm") {}
shared object buttonSizeExtraSmall extends ButtonSize("btn-xs") {}

shared abstract class ButtonType(shared String clazz) of buttonTypeDefault|buttonTypePrimary|buttonTypeSuccess|buttonTypeInfo|buttonTypeWarning|buttonTypeDanger|buttonTypeLink {}
shared object buttonTypeDefault extends ButtonType("btn-default") {}
shared object buttonTypePrimary extends ButtonType("btn-primary") {}
shared object buttonTypeSuccess extends ButtonType("btn-success") {}
shared object buttonTypeInfo extends ButtonType("btn-info") {}
shared object buttonTypeWarning extends ButtonType("btn-warning") {}
shared object buttonTypeDanger extends ButtonType("btn-danger") {}
shared object buttonTypeLink extends ButtonType("btn-link") {}

shared Component<Input,HtmlPhrasing> button<in Input>(String name, ButtonSize size, ButtonType type) given Input satisfies Value =>
		button_ { attrType("button"), attrClass("btn ``size.clazz`` ``type.clazz``"), name };


