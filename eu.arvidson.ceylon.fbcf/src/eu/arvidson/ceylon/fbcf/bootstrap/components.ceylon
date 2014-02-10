import eu.arvidson.ceylon.fbcf.html5 { nav, attrRole, HtmlFlow, attrClass, div, button_=button, attrType, attrData, span, a, p, b, attrHref, ul, li, HtmlLi, SimpleContent, h1, HtmlPhrasing, img, attrAlt, strong, attrStyle, attrAria, h4 }
import eu.arvidson.ceylon.fbcf.base { Component, Value, stringList, string, ConstantOrBinding, rootBuilder, ShowIfExists, conditional, const, ShowIfTrue }

shared Component<Input,HtmlFlow> row<in Input>({Component<Input, HtmlFlow>*} content) given Input satisfies Value
		=> div({ attrClass("row"), *content });


shared abstract class DeviceType(shared actual String string) of deviceTypeExtraSmall|deviceTypeSmall|deviceTypeMedium|deviceTypeLarge {}
shared object deviceTypeExtraSmall extends DeviceType("xs") {}
shared object deviceTypeSmall extends DeviceType("sm") {}
shared object deviceTypeMedium extends DeviceType("md") {}
shared object deviceTypeLarge extends DeviceType("lg") {}

shared Component<Input,HtmlFlow> column<in Input>(DeviceType deviceType, Integer width, {Component<Input, HtmlFlow>*} content) given Input satisfies Value
	=> div({ attrClass( "col-``deviceType.string``-``width.string``"), *content });

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

shared Component<Input,HtmlLi> menuItem<in Input>(String href, String header, Boolean active = false) given Input satisfies Value 
		=> li<Input> { active then attrClass("active") else null, a { attrHref("#``href``"), header }};

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
shared Component<Input,HtmlLi> menuDropdownDivider<in Input>() given Input satisfies Value 
		=> li { attrClass("divider") };
shared Component<Input,HtmlLi> menuDropdownHeader<in Input>(String text) given Input satisfies Value 
		=> li { attrClass("dropdown-header"), text };

shared Component<Input,HtmlFlow> jumbotron<in Input>(String title, SimpleContent<Input, HtmlFlow>* content) given Input satisfies Value 
		=> div { attrClass("jumbotron"), h1 { title }, *content };

shared Component<Input,HtmlFlow> pageHeader<in Input>(String title) given Input satisfies Value 
		=> div { attrClass("page-header"), h1 { title } };

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

shared Component<Input,HtmlPhrasing> button<in Input>(String name, ButtonSize size, ButtonType type) given Input satisfies Value 
		=> button_ { attrType("button"), attrClass("btn ``size.clazz`` ``type.clazz``"), name };

shared Component<Input,HtmlPhrasing> thumbnail<in Input>(String src, Integer width, Integer height, String description) given Input satisfies Value 
		=> img { attrData("src", "``src``/``width``x``height``"), attrClass("img-thumbnail"), attrAlt(description) };

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

shared abstract class AlertType(shared String clazz) of alertTypeSuccess|alertTypeInfo|alertTypeWarning|alertTypeDanger {}
shared object alertTypeSuccess extends AlertType("alert-success") {}
shared object alertTypeInfo extends AlertType("alert-info") {}
shared object alertTypeWarning extends AlertType("alert-warning") {}
shared object alertTypeDanger extends AlertType("alert-danger") {}

shared Component<Value<InputGet, InputSet>,HtmlFlow> alert<in InputGet,out InputSet>(type, title, message) {
	AlertType type;
	ConstantOrBinding<Value<InputGet, InputSet>, String?> title;
	ConstantOrBinding<Value<InputGet, InputSet>, String> message;

	value builder = rootBuilder<InputGet, InputSet>();
	value titleBinding = builder.outputReadOnly<String>().binding;

	return div { 
		attrClass("alert ``type.clazz``"), 
		ShowIfExists(builder.constOrBinding<String?>(title).binding, titleBinding, { strong { titleBinding } }), " ", message 
	};
}

shared abstract class ProgressType(shared String clazz) of progressTypeStandard|progressTypeSuccess|progressTypeInfo|progressTypeWarning|progressTypeDanger {}
shared object progressTypeStandard extends ProgressType("") {}
shared object progressTypeSuccess extends ProgressType("progress-bar-success") {}
shared object progressTypeInfo extends ProgressType("progress-bar-info") {}
shared object progressTypeWarning extends ProgressType("progress-bar-warning") {}
shared object progressTypeDanger extends ProgressType("progress-bar-danger") {}

shared interface ProgressBar satisfies HtmlFlow {}

String toProgressString(Integer val) {
	if (val < 0) {
		return "0";
	} else if (val > 100) {
		return "100";
	} else {
		return val.string;
	}
}

shared Component<Input,HtmlFlow> progress<in Input>({Component<Input, ProgressBar>*} bars) given Input satisfies Value 
	=> div<Input> ({ attrClass<Input>("progress"), *bars });

shared Component<Value<InputGet, InputSet>,ProgressBar> progressBar<in InputGet,out InputSet>(type, progress, message) {
	ConstantOrBinding<Value<InputGet, InputSet>,ProgressType> type; 
	ConstantOrBinding<Value<InputGet, InputSet>,Integer> progress; 
	ConstantOrBinding<Value<InputGet, InputSet>,String> message;
	
	value builder = rootBuilder<InputGet, InputSet>();
	value progressBinding = builder.constOrBinding<Integer>(progress).fun(toProgressString).binding;
	
	return div {
		attrClass(stringList { "progress-bar", builder.constOrBinding<ProgressType>(type).attr(`ProgressType.clazz`).binding }), 
		attrRole("progressbar"), 
		attrAria("valuenow", progressBinding), 
		attrAria("valuemin", "0"), 
		attrAria("valuemax", "100"),
		attrStyle(string { "width: ", progressBinding, "%" }),
		span { attrClass("sr-only"), message } 
	};
}

shared Component<Value<InputGet, InputSet>,HtmlFlow> simpleProgress<in InputGet,out InputSet>(type, progress, message) {
	ConstantOrBinding<Value<InputGet, InputSet>,ProgressType> type; 
	ConstantOrBinding<Value<InputGet, InputSet>,Integer> progress; 
	ConstantOrBinding<Value<InputGet, InputSet>,String> message;
	
	return div { attrClass("progress"), progressBar(type, progress, message) };
}

shared interface LinkListGroupItem satisfies HtmlFlow {}

shared Component<Input,HtmlFlow> linkListGroup<in Input>({Component<Input, LinkListGroupItem>*} items) given Input satisfies Value
	=> div({ attrClass("list-group"), *items});

shared Component<Value<InputGet, InputSet>,LinkListGroupItem> linkListGroupItem<in InputGet,out InputSet>(href, active, heading, text) {
	ConstantOrBinding<Value<InputGet, InputSet>, String?> href;
	ConstantOrBinding<Value<InputGet, InputSet>, Boolean> active;
	ConstantOrBinding<Value<InputGet, InputSet>, String?> heading;
	ConstantOrBinding<Value<InputGet, InputSet>, String?> text;
	
	value builder = rootBuilder<InputGet, InputSet>();
	value headingBuilder = builder.constOrBinding<String?>(heading);
	value textBinding = builder.constOrBinding<String?>(text).binding;
	return a {
		attrHref(href),
		attrClass(stringList {"list-group-item", conditional(builder.constOrBinding<Boolean>(active).binding, const("active"), const(null)) }),
		ShowIfTrue(headingBuilder.isNotNull().binding, { 
			h4 { attrClass("list-group-item-heading"), headingBuilder.binding },
			p { attrClass("list-group-item-text"), textBinding } 
		}),
		ShowIfTrue(headingBuilder.isNull().binding, {
			textBinding
		})
	};
}

shared interface ListGroupItem satisfies HtmlLi {}
shared Component<Input,HtmlFlow> listGroup<in Input>({Component<Input, ListGroupItem>*} items) given Input satisfies Value
		=> ul({ attrClass("list-group"), *items});

shared Component<Value<InputGet, InputSet>,ListGroupItem> listGroupItem<in InputGet,out InputSet>(active, heading, text) {
	ConstantOrBinding<Value<InputGet, InputSet>, Boolean> active;
	ConstantOrBinding<Value<InputGet, InputSet>, String?> heading;
	ConstantOrBinding<Value<InputGet, InputSet>, String?> text;
	
	value builder = rootBuilder<InputGet, InputSet>();
	value headingBuilder = builder.constOrBinding<String?>(heading);
	value textBinding = builder.constOrBinding<String?>(text).binding;
	return li {
		attrClass(stringList {"list-group-item", conditional(builder.constOrBinding<Boolean>(active).binding, const("active"), const(null)) }),
		ShowIfTrue(headingBuilder.isNotNull().binding, { 
			h4 { attrClass("list-group-item-heading"), headingBuilder.binding },
			p { attrClass("list-group-item-text"), textBinding } 
		}),
		ShowIfTrue(headingBuilder.isNull().binding, {
			textBinding
		})
	};
}
