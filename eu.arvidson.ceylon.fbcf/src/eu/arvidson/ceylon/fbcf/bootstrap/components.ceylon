import eu.arvidson.ceylon.fbcf.html5 { nav, attrRole, HtmlFlow, attrClass, div }
import eu.arvidson.ceylon.fbcf.base { Component, Value }

shared interface Navbar satisfies HtmlFlow {}

Component<Input,Navbar> navbar<in Input>() given Input satisfies Value => nav<Input,Navbar> {
	attrClass("navbar navbar-inverse navbar-fixed-top"), 
	attrRole("navigation"),
	div {
		attrClass("container")  
	} 
};