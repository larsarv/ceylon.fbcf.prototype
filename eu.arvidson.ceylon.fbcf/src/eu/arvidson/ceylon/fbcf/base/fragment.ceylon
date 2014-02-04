alias FragmentComponentWorkaround<in T1,T2> given T1 satisfies Value  => Component<T1,T2>;

shared alias FragmentContent<in Input,out Type> given Input satisfies Value => String|OptionalStringBinding<Input,Nothing>|Component<Input,Type>;
shared class Fragment<in Input,out Type>(content) satisfies Component<Input,Type> given Input satisfies Value {
	{FragmentContent<Input,Type>+} content;
	
	shared actual Template<Input,Type> build() {
		value linkerListBuilder = SequenceBuilder<Linker<Input>>();
		dynamic fragmentNode;
		dynamic firstChild;
		dynamic {
			dynamic fragment = document.createDocumentFragment();
			fragmentNode = fragment;
			
			for (FragmentContent<Input,Type> child in content) {
				if (is String child) {
					if (!child.empty) {
						fragment.appendChild(document.createTextNode(child));
					}
				} else if (is OptionalStringBinding<Input,Nothing> child) {
					Template<Input,String> tmp = Text(child).build();
					if (exists linker = tmp.linker) {
						linkerListBuilder.append(linker);
					}
					fragment.appendChild(tmp.node);
				} else if (is FragmentComponentWorkaround<Input,Type> child) { // TODO Ceylon js bug!!! Was forced to do a type alias to get this to work....
					Template<Input,Type> tmp = child.build();
					if (exists linker = tmp.linker) {
						linkerListBuilder.append(linker);
					}
					fragment.appendChild(tmp.node);
				} else {
					throw Exception("Unknown content type " + child.string);
				}
			}
			
			firstChild = fragment.firstChild;
			
			{Linker<Input>*} linkers = linkerListBuilder.sequence;
			if (linkers.empty) {
				return Template<Input,Type>(fragmentNode, null);
			} else if (linkers.size == 1) {
				return Template<Input,Type>(fragmentNode, linkers.first);
			} else {
				return Template<Input,Type>(fragmentNode, SeqenceLinker(firstChild, linkers));
			}
		}
		
	}
}
