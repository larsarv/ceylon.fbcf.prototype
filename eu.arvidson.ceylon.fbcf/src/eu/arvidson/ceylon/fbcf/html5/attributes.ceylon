import eu.arvidson.ceylon.fbcf.base { Attribute, AttributeValue, Value }

shared Attribute<Input> attrAccesskey<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("accesskey", val);
shared Attribute<Input> attrClass<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("class", val);
shared Attribute<Input> attrContenteditable<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("contenteditable", val);
shared Attribute<Input> attrContextmenu<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("contextmenu", val);
shared Attribute<Input> attrDir<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("dir", val);
shared Attribute<Input> attrDraggable<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("draggable", val);
shared Attribute<Input> attrDropzone<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("dropzone", val);
shared Attribute<Input> attrHidden<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("hidden", val);
shared Attribute<Input> attrId<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("id", val);
shared Attribute<Input> attrInert<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("inert", val);
shared Attribute<Input> attrItemid<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("itemid", val);
shared Attribute<Input> attrItemprop<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("itemprop", val);
shared Attribute<Input> attrItemref<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("itemref", val);
shared Attribute<Input> attrItemscope<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("itemscope", val);
shared Attribute<Input> attrItemtype<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("itemtype", val);
shared Attribute<Input> attrLang<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("lang", val);
shared Attribute<Input> attrSpellcheck<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("spellcheck", val);
shared Attribute<Input> attrStyle<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("style", val);
shared Attribute<Input> attrTabindex<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("tabindex", val);
shared Attribute<Input> attrTitle<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("title", val);
shared Attribute<Input> attrTranslate<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("translate", val);
shared Attribute<Input> attrData<in Input>(String name, AttributeValue<Input> val) given Input satisfies Value => Attribute("data-" + name, val);

// html
shared Attribute<Input> attrManifest<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("manifest", val);
// base, link, a, area
shared Attribute<Input> attrHref<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("href", val);
// base, area, form
shared Attribute<Input> attrTarget<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("target", val);
// link, img, video, audio
shared Attribute<Input> attrCrossorigin<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("crossorigin", val);
// link, a, area
shared Attribute<Input> attrRel<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("rel", val);

shared Attribute<Input> attrRole<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("role", val);
shared Attribute<Input> attrAria<in Input>(String name, AttributeValue<Input> val) given Input satisfies Value => Attribute("aria-" + name, val);

// link, style, source
shared Attribute<Input> attrMedia<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("media", val);
// link, a, area
shared Attribute<Input> attrHreflang<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("hreflang", val);
// link, style, a, embed, object, source, area, input, button, menu, menuitem
shared Attribute<Input> attrType<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("type", val);
// link
shared Attribute<Input> attrSizes<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("sizes", val);
// meta, iframe, object, param, map, form, fieldset, input, button, select, textarea, keygen, output
shared Attribute<Input> attrName<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("name", val);
// meta 
shared Attribute<Input> attrHttp_equiv<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("http-equiv", val);
// meta 
shared Attribute<Input> attrContent<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("content", val);
// meta 
shared Attribute<Input> attrCharset<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("charset", val);
// style
shared Attribute<Input> attrScoped<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("scoped", val);
// src, img, iframe, embed, video, audio, source, track, input
shared Attribute<Input> attrSrc<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("src", val);
// style  
shared Attribute<Input> attrAsync<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("async", val);
// style  
shared Attribute<Input> attrDefer<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("defer", val);
// blockquote, q, ins, del
shared Attribute<Input> attrCite<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("cite", val);
// ol
shared Attribute<Input> attrReversed<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("reversed", val);
// ol
shared Attribute<Input> attrStart<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("start", val);
// li, data, param, input, button, option, progress, meter
shared Attribute<Input> attrValue<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("value", val);
// a, area
shared Attribute<Input> attrDownload<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("download", val);
// time, ins, del
shared Attribute<Input> attrDatetime<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("datetime", val);
// img, area, input
shared Attribute<Input> attrAlt<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("alt", val);
// img, object
shared Attribute<Input> attrUsemap<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("usemap", val);
// img
shared Attribute<Input> attrIsmap<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("ismap", val);
// img, iframe, embed, object, video, canvas, input
shared Attribute<Input> attrWidth<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("width", val);
// img, iframe, embed, object, video, canvas, input
shared Attribute<Input> attrHeight<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("height", val);
// iframe
shared Attribute<Input> attrSrcdoc<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("srcdoc", val);
// iframe
shared Attribute<Input> attrSandbox<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("sandbox", val);
// iframe
shared Attribute<Input> attrSeamless<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("seamless", val);
// iframe
shared Attribute<Input> attrAllowfullscreen<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("allowfullscreen", val);
// object
shared Attribute<Input> attrTypemustmatch<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("typemustmatch", val);
// object, fieldset, label, input, select, textarea, keygen, output
shared Attribute<Input> attrForm<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("form", val);
// video
shared Attribute<Input> attrPoster<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("poster", val);
// video, audio
shared Attribute<Input> attrPreload<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("preload", val);
// video, audio
shared Attribute<Input> attrAutoplay<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("autoplay", val);
// video, audio
shared Attribute<Input> attrMediagroup<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("mediagroup", val);
// video, audio
shared Attribute<Input> attrLoop<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("loop", val);
// video, audio
shared Attribute<Input> attrMuted<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("muted", val);
// video, audio
shared Attribute<Input> attrControls<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("controls", val);
// track
shared Attribute<Input> attrKind<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("kind", val);
// track
shared Attribute<Input> attrSrclang<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("srclang", val);
// track, optgroup, option, menu, menuitem
shared Attribute<Input> attrLabel<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("label", val);
// track, menuitem
shared Attribute<Input> attrDefault<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("default", val);
// area
shared Attribute<Input> attrCords<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("cords", val);
// area
shared Attribute<Input> attrShape<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("shape", val);
// table
shared Attribute<Input> attrBorder<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("border", val);
// table
shared Attribute<Input> attrSortable<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("sortable", val);
// colgroup, col
shared Attribute<Input> attrSpan<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("span", val);
// td, th
shared Attribute<Input> attrColspan<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("colspan", val);
// td, th
shared Attribute<Input> attrRowspan<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("rowspan", val);
// td, th
shared Attribute<Input> attrHeaders<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("headers", val);
// th
shared Attribute<Input> attrScope<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("scope", val);
// th
shared Attribute<Input> attrAbbr<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("abbr", val);
// th
shared Attribute<Input> attrSorted<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("sorted", val);
// form
shared Attribute<Input> attrAccept_charset<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("accept-charset", val);
// form
shared Attribute<Input> attrAction<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("action", val);
// form, input, textarea
shared Attribute<Input> attrAutocomplete<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("autocomplete", val);
// form
shared Attribute<Input> attrEnctype<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("enctype", val);
// form
shared Attribute<Input> attrMethod<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("method", val);
// form, button
shared Attribute<Input> attrNovalidate<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("novalidate", val);
// fieldset, input, button, select, optgroup, option, textarea, keygen, menuitem
shared Attribute<Input> attrDisabled<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("disabled", val);
// label, output
shared Attribute<Input> attrFor<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("for", val);
// input
shared Attribute<Input> attrAccept<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("accept", val);
// input, button, select, keygen
shared Attribute<Input> attrAutofocus<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("autofocus", val);
// input, menuitem
shared Attribute<Input> attrChecked<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("checked", val);
// input, textarea
shared Attribute<Input> attrDirname<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("dirname", val);
// input, button
shared Attribute<Input> attrFormaction<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("formaction", val);
// input, button
shared Attribute<Input> attrFormenctype<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("formenctype", val);
// input, button
shared Attribute<Input> attrFormmethod<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("formmethod", val);
// input, button
shared Attribute<Input> attrFormnovalidate<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("formnovalidate", val);
// input, button
shared Attribute<Input> attrFormtarget<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("formtarget", val);
// input, textarea
shared Attribute<Input> attrInputmode<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("inputmode", val);
// input
shared Attribute<Input> attrList<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("list", val);
// input, progress, meter
shared Attribute<Input> attrMax<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("max", val);
// input, textarea
shared Attribute<Input> attrMaxlength<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("maxlength", val);
// input, meter
shared Attribute<Input> attrMin<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("min", val);
// input, select
shared Attribute<Input> attrMultiple<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("multiple", val);
// input
shared Attribute<Input> attrPattern<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("pattern", val);
// input, textarea
shared Attribute<Input> attrPlaceholder<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute<Input>("placeholder", val);
// input, textarea
shared Attribute<Input> attrReadonly<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("readonly", val);
// input, select, textarea
shared Attribute<Input> attrRequired<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("required", val);
// input, select
shared Attribute<Input> attrSize<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("size", val);
// input
shared Attribute<Input> attrStep<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("step", val);
// button
shared Attribute<Input> attrMenu<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("menu", val);
// option
shared Attribute<Input> attrSelected<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("selected", val);
// textarea
shared Attribute<Input> attrCols<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("cols", val);
// textarea
shared Attribute<Input> attrRows<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("rows", val);
// textarea
shared Attribute<Input> attrWrap<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("wrap", val);
// keygen
shared Attribute<Input> attrChallenge<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("challenge", val);
// keygen
shared Attribute<Input> attrKeytype<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("keytype", val);
// meter
shared Attribute<Input> attrLow<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("low", val);
// meter
shared Attribute<Input> attrHigh<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("high", val);
// meter
shared Attribute<Input> attrOptimum<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("optimum", val);
// details, dialog
shared Attribute<Input> attrOpen<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("open", val);
// menuitem
shared Attribute<Input> attrIcon<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("icon", val);
// menuitem
shared Attribute<Input> attrRadiogroup<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("radiogroup", val);
// menuitem
shared Attribute<Input> attrCommand<in Input>(AttributeValue<Input> val) given Input satisfies Value => Attribute("command", val);


