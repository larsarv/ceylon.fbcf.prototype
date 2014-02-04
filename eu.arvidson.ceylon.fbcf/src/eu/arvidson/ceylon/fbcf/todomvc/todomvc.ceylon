import eu.arvidson.ceylon.fbcf.base { simpleROValue, Template, Fragment, roroot, Text, Repeat, Value, noargs, stringList, initializeAndAppendToBody, Tuple1, TemplateInstanceContext }
import eu.arvidson.ceylon.fbcf.html5 { section, header, h1, input, ul, label, footer, span, strong, p, a, div, button, li, attrId, attrType, attrFor, attrHref, attrClass, attrStyle, attrPlaceholder, onClick, onDblClick, propValue, onEnter, propChecked, doFocus, onBlur, HtmlFlow }



shared abstract class TodoFilter() of all | completed | todo {}
shared object all extends TodoFilter() {}
shared object completed extends TodoFilter() {}
shared object todo extends TodoFilter() {}

shared class TodoItem(description) {
	shared variable Boolean done = false;
	shared variable String? description;
}


shared class TodoList() {
	shared variable String? newTodo = null;
	//shared variable { TodoItem *} items = [ for (i in 1..500) TodoItem("Item ``i``") ].sequence;
	shared variable { TodoItem *} items = empty;
	shared variable TodoItem? editItem = null;

	shared Boolean isEdit(TodoItem item) {
		if (exists editItem = editItem, item === editItem) {
			return true;
		} else {
			return false;
		}
	}
	shared void startEdit(TodoItem item) {
		editItem = item;
	}
	shared void endEdit() {
		editItem = null;
	}
	
	shared variable TodoFilter filter = all; 
	shared void setFilterAll() {
		filter = all;
	}
	shared void setFilterCompleted() {
		filter = completed;
	}
	shared void setFilterTodo() {
		filter = todo;
	}
	
	shared {TodoItem*} filteredItems() {
		switch (filter)
		case (all) {
			return items;
		}
		case (todo) {
			return items.filter((TodoItem elem) => !elem.done);
		}
		case (completed) {
			return items.filter((TodoItem elem) => elem.done);
		}
		
	}
	
	shared void addTodo() {
		if (exists tmp = newTodo, tmp.size > 0) {
			items = items.following(TodoItem(tmp));
			newTodo = null;
		}
	}
	
	shared Integer todoCount() {
		return items.count((TodoItem element) => !element.done);
	}
	shared Integer completedCount() {
		return items.count((TodoItem element) => element.done);
	}
	
	shared Boolean allChecked => items.every((TodoItem e) => e.done);
	assign allChecked {
		for (item in items) {
			item.done = allChecked;
		}
	}
	
	shared void removeItem(TodoItem item) {
		items = items.select((TodoItem element) => element != item);
	}
	shared void removeCompleted() {
		items = items.select((TodoItem element) => !element.done);
	}
}

shared class TodoMvc() {
	Template<Value<TodoList, Nothing>,HtmlFlow> buildTemplate() {
		value app = roroot<TodoList>();
		value item = app.roroot<TodoItem>();
		value filter = app.attr(`TodoList.filter`);
		value completedCount = app.method(`TodoList.completedCount`);
		value itemDone = item.attr(`TodoItem.done`);
		value itemEdit = app.methodWithArgs(`TodoList.isEdit`, Tuple1(item.binding));
		value endEdit = app.callableMethod(`TodoList.endEdit`, noargs);
	
		return Fragment {
			section { 
				attrId("todoapp"),
				header {
					attrId("header"), 
					h1 { "todos" }, 
					input {
						attrId("new-todo"),
						attrType("text"), 
						attrPlaceholder("What needs to be done?"),
						propValue(app.attr(`TodoList.newTodo`).binding), 
						onEnter(app.callableMethod(`TodoList.addTodo`, noargs).binding)  
					}
				}, 
				section { 
					attrId("main"), 
					input { 
						attrId("toggle-all"),
						attrType("checkbox"), 
						propChecked(app.attr(`TodoList.allChecked`).binding),
						onClick(app.nop().binding)
					},
					label { attrFor("toggle-all"), "Mark all as complete" },
					ul { 
						attrId("todo-list"),
						Repeat { 
							argument = app.method(`TodoList.filteredItems`).binding; 
							output = item.binding;
							li {
								attrClass(stringList {
									[itemDone.binding, "completed"],
									[itemEdit.binding, "editing"]
								}),
								//itemDone.conditional(true, "completed", null).binding,
								div { 
									attrClass("view"),
									input {
										attrClass("toggle"),
										attrType("checkbox"),
										propChecked(itemDone.binding),
										onClick(app.nop().binding)
									}, 
									label {
										onDblClick(app.callableMethod(`TodoList.startEdit`, Tuple1(item.binding)).binding),
										item.attr(`TodoItem.description`).binding
									},
									button {
										attrClass("destroy"),
										onClick(app.callableMethod(`TodoList.removeItem`, Tuple1(item.binding)).binding) 
									}
								},
								input { 
									attrType("text"),
									attrClass("edit"),
									propValue(item.attr(`TodoItem.description`).binding), 
									onEnter(endEdit.binding),
									onBlur(endEdit.binding),
									doFocus(itemEdit.binding)
								}
							}
						} 
					}
				},
				footer { 
					attrId("footer"),
					span { 
						attrId("todo-count"), 
						strong { Text(app.method(`TodoList.todoCount`).binding) },
						" item left"
					},
					ul {
						attrId("filters"),
						li { a { "All", attrHref("#/"), attrClass(filter.conditional(all, "selected", null).binding), onClick( app.callableMethod(`TodoList.setFilterAll`, noargs).binding) } },
						li { a { "Active", attrHref("#/"), attrClass(filter.conditional(todo, "selected", null).binding), onClick( app.callableMethod(`TodoList.setFilterTodo`, noargs).binding) } },
						li { a { "Completed", attrHref("#/"), attrClass(filter.conditional(completed, "selected", null).binding), onClick( app.callableMethod(`TodoList.setFilterCompleted`, noargs).binding) } }
					},
					button {
						attrId("clear-completed"),
						attrStyle(completedCount.conditional(0, "display: none;", null).binding),
						onClick(app.callableMethod(`TodoList.removeCompleted`, noargs).binding), 
						"Clear completed (", Text(completedCount.binding) , ")"
					}
				}
			},
			footer { 
				attrId("info"),
				p { "Double-click to edit a todo" },
				p { "Created by ", a { attrHref("http://github.com/larsarv"), "Lars Arvidson" } },
				p { /* "Part of ", a { attrHref("http://todomvc.com"), "TodoMVC" } */ }
			}			
		}.build();
	}
	
	shared void run() {
		initializeAndAppendToBody((TemplateInstanceContext context) {
			return buildTemplate().instantiate(context, simpleROValue(TodoList()));
		});
	}
}
