import eu.arvidson.ceylon.fbcf.html5 { nav, attrRole, HtmlFlow, attrClass, div, button_=button, attrType, attrData, span, a, b, attrHref, ul, li, HtmlLi, CommonContent, SimpleContent, h1, HtmlPhrasing, img, attrAlt, strong, attrStyle, attrAria }
import eu.arvidson.ceylon.fbcf.base { Component, Value, Binding, stringList, BindingBuilder, const, builder, string }

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

shared Component<Input,HtmlFlow> alert<in Input>(AlertType type, String? title, String message) given Input satisfies Value 
		=> div { attrClass("alert ``type.clazz``"), strong { title }, " ", message };

shared abstract class ProgressType(shared String clazz) of progressTypeStandard|progressTypeSuccess|progressTypeInfo|progressTypeWarning|progressTypeDanger {}
shared object progressTypeStandard extends ProgressType("") {}
shared object progressTypeSuccess extends ProgressType("progress-bar-success") {}
shared object progressTypeInfo extends ProgressType("progress-bar-info") {}
shared object progressTypeWarning extends ProgressType("progress-bar-warning") {}
shared object progressTypeDanger extends ProgressType("progress-bar-danger") {}

shared interface ProgressBar satisfies HtmlFlow {}

shared alias ConstantOrBinding<in Input, out Type> given Input satisfies Value => Type|Binding<Input, Value<Type,Nothing>>;
shared alias ReadBinding<in Input, out Type> given Input satisfies Value => Binding<Input, Value<Type,Nothing>>;

String toProgressString(Integer val) {
	if (val < 0) {
		return "0";
	} else if (val > 100) {
		return "100";
	} else {
		return val.string;
	}
}
shared Component<Value<InputGet, InputSet>,HtmlFlow> simpleProgress<InputGet, InputSet>(Binding<Value<InputGet, InputSet>,Value<ProgressType,Nothing>> type, ReadBinding<Value<InputGet, InputSet>,Integer> progress, ReadBinding<Value<InputGet, InputSet>,String> message) {
	return div<Value<InputGet, InputSet>> {
		attrClass("progress"),
		div<Value<InputGet, InputSet>,ProgressBar> { 
			attrClass(stringList { "progress-bar", builder(type).attr(`ProgressType.clazz`).binding }), 
			attrRole("progressbar"), 
			attrAria("valuenow", builder(progress).attr(`Integer.string`).binding), 
			attrAria("valuemin", "0"), 
			attrAria("valuemax", "0"),
			attrStyle(string { "width: ", builder(progress).fun(toProgressString).binding, "%" }),
			span { attrClass("sr-only"), message } 
		}
	};
}

shared Component<Input,HtmlFlow> progress<in Input>({Component<Input, ProgressBar>*} bars) given Input satisfies Value 
		=> div<Input> ( bars.following(attrClass<Input>("progress")) ); // TODO FIX Once backend bug is fixed...

shared Component<Input,ProgressBar> progressBar<in Input>(ProgressType type, Integer progress, String message) given Input satisfies Value {
	return div<Input,ProgressBar> { 
		attrClass("progress-bar ``type.clazz``"), 
		attrRole("progressbar"), 
		attrAria("valuenow", progress.string), 
		attrAria("valuemin", "0"), 
		attrAria("valuemax", "0"),
		attrStyle("width: ``progress``%"),
		span { attrClass("sr-only"), message } 
 	};
}