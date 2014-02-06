import eu.arvidson.ceylon.fbcf.html5 { nav, attrRole, HtmlFlow, attrClass, div, button_=button, attrType, attrData, span, a, b, attrHref, ul, li, HtmlLi, CommonContent, SimpleContent, h1, HtmlPhrasing, img, attrAlt }
import eu.arvidson.ceylon.fbcf.base { Component, Value }

shared abstract class NavbarType(shared String clazz) of navbarInverse|navbarStandard {}
shared object navbarInverse extends NavbarType("navbar-inverse") {}
shared object navbarStandard extends NavbarType("navbar-default") {}

Component<Input,HtmlFlow> navbar<in Input>(NavbarType type, Boolean fixedTop, String header, Component<Input,HtmlLi> *items) given Input satisfies Value {
	return nav<Input> {
		attrClass("navbar ``type.clazz`` ``(fixedTop then "navbar-fixed-top" else "")``"), 
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

shared Component<Input,HtmlLi> menuItem<in Input>(String href, String header, Boolean active = false) given Input satisfies Value => 
		li<Input> { active then attrClass("active") else null, a { attrHref("#``href``"), header }};

shared Component<Input,HtmlLi> menuDropdown<in Input>(String header, Component<Input,HtmlLi> *items) given Input satisfies Value {
	return li<Input> { 
		attrClass("nav navbar-nav"), 
		a { attrHref("#"), attrClass("dropdown-toggle"), attrData("toggle", "dropdown"), header ," ", b { attrClass("caret") }},
		ul {
			attrClass("dropdown-menu"),
			*items
		}
	};
}
shared Component<Input,HtmlLi> menuDropdownDivider<in Input>() given Input satisfies Value => 
		li { attrClass("divider") };
shared Component<Input,HtmlLi> menuDropdownHeader<in Input>(String text) given Input satisfies Value => 
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

shared Component<Input,HtmlPhrasing> thumbnail<in Input>(String src, Integer width, Integer height, String description) given Input satisfies Value =>
		img { attrData("src", "``src``/``width``x``height``"), attrClass("img-thumbnail"), attrAlt(description) };

shared Component<Input,HtmlFlow> dropdown<in Input>(String header, Component<Input,HtmlLi> *items) given Input satisfies Value {
	return div<Input> { 
		attrClass("dropdown theme-dropdown clearfix"), 
		a { attrHref("#"), attrClass("sr-only dropdown-toggle"), attrData("toggle", "dropdown"), header ," ", b { attrClass("caret") }},
		ul {
			attrClass("dropdown-menu"),
			*items
		}
	};
}