import eu.arvidson.ceylon.fbcf.component { Component, Element, OptionalStringBinding, Value, OriginalElementModifier=ElementModifier, Property, Attribute, EventHandler }

shared interface HtmlFlow {}
//shared interface HtmlHeadingContent satisfies HtmlFlow {}
//shared interface HtmlSectioningContent satisfies HtmlFlow {}
shared interface HtmlPhrasing satisfies HtmlFlow {}

//shared interface HtmlEmbedded satisfies HtmlPhrasing {}
//shared interface HtmlInteractive satisfies HtmlFlow {}
//shared interface HtmlMetadata satisfies HtmlFlow {}

shared interface HtmlLi {}
shared interface HtmlDt {}
shared interface HtmlDd {}
shared interface HtmlFigcaption {}
shared interface HtmlParam {}
shared interface HtmlTrack {}
shared interface HtmlSource {}
shared interface HtmlTableContent {}
shared interface HtmlCol {}
shared interface HtmlTr satisfies HtmlTableContent {}
shared interface HtmlTd {}
shared interface HtmlTh {}
shared interface HtmlLegend {}
shared interface HtmlOption {}
shared interface HtmlOptgroup {}
shared interface HtmlSummary {}

shared alias CommonContent<in Input,out Type> given Input satisfies Value => OriginalElementModifier<Input>|String|OptionalStringBinding<Input,Nothing>|Component<Input,Type|String>|Null;
shared alias ElementModifier<in Input> given Input satisfies Value => OriginalElementModifier<Input>|Null;


// 4.1
//shared Component<Input,Nothing> html<in Input>({CommonContent<Input,Nothing>*} content = empty) given Input satisfies Value => Element<Input,Nothing>("html", content);
// 4.2
//shared Component<Input> head<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("head", content);
//shared Component<Input> title<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("title", content);
//shared Component<Input> base<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("base", content);
//shared Component<Input> link<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("link", content);
//shared Component<Input> meta<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("meta", content);
//shared Component<Input> style<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("style", content);
// 4.3
//shared Component<Input> script<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("script", content);
//shared Component<Input> noScript<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("noscript", content);
//shared Component<Input> template<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("template", content);
// 4.4 Sections
//shared Component<Input> body<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("body", content);
shared Component<Input,HtmlFlow> article<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("article", content);
shared Component<Input,HtmlFlow> section<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("section", content);
shared Component<Input,HtmlFlow> nav<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("nav", content);
shared Component<Input,HtmlFlow> aside<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("aside", content);
shared Component<Input,HtmlFlow> h1<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h1", content);
shared Component<Input,HtmlFlow> h2<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h2", content);
shared Component<Input,HtmlFlow> h3<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h3", content);
shared Component<Input,HtmlFlow> h4<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h4", content);
shared Component<Input,HtmlFlow> h5<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h5", content);
shared Component<Input,HtmlFlow> h6<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("h6", content);
shared Component<Input,HtmlFlow> header<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("header", content);
shared Component<Input,HtmlFlow> footer<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("footer", content);
shared Component<Input,HtmlFlow> address<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("address", content);
// 4.5 Grouping content
shared Component<Input,HtmlFlow> p<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("p", content);
shared Component<Input,HtmlFlow> hr<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("hr", content);
shared Component<Input,HtmlFlow> pre<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("pre", content);
shared Component<Input,HtmlFlow> blockquote<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("blockquote", content);
shared Component<Input,HtmlFlow> ol<in Input>({ElementModifier<Input>|Component<Input,HtmlLi>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("ol", content);
shared Component<Input,HtmlFlow> ul<in Input>({ElementModifier<Input>|Component<Input,HtmlLi>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("ul", content);
shared Component<Input,HtmlLi> li<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlLi>("li", content);
shared Component<Input,HtmlFlow> dl<in Input>({ElementModifier<Input>|Component<Input,HtmlDt|HtmlDd>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("dl", content);
shared Component<Input,HtmlDt> dt<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlDt>("dt", content);
shared Component<Input,HtmlDd> dd<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlDd>("dd", content);
shared Component<Input,HtmlFlow> figure<in Input>({CommonContent<Input,HtmlFlow|HtmlFigcaption>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("figure", content);
shared Component<Input,HtmlFigcaption> figcaption<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFigcaption>("figcaption", content);
shared Component<Input,HtmlFlow> div<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("div", content);
shared Component<Input,HtmlFlow> main<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("main", content);
// 4.6 Text-level semantics
shared Component<Input,HtmlPhrasing> a<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("a", content);
shared Component<Input,HtmlPhrasing> em<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("em", content);
shared Component<Input,HtmlPhrasing> strong<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("strong", content);
shared Component<Input,HtmlPhrasing> small<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("small", content);
shared Component<Input,HtmlPhrasing> s<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("s", content);
shared Component<Input,HtmlPhrasing> cite<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("cite", content);
shared Component<Input,HtmlPhrasing> q<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("q", content);
shared Component<Input,HtmlPhrasing> dfn<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("dfn", content);
shared Component<Input,HtmlPhrasing> abbr<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("abbr", content);
shared Component<Input,HtmlPhrasing> data<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("data", content);
shared Component<Input,HtmlPhrasing> time<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("time", content);
shared Component<Input,HtmlPhrasing> code<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("code", content);
shared Component<Input,HtmlPhrasing> var<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("var", content);
shared Component<Input,HtmlPhrasing> samp<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("samp", content);
shared Component<Input,HtmlPhrasing> kbd<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("kbd", content);
shared Component<Input,HtmlPhrasing> sub<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("sub", content);
shared Component<Input,HtmlPhrasing> sup<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("sup", content);
shared Component<Input,HtmlPhrasing> i<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("i", content);
shared Component<Input,HtmlPhrasing> b<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("b", content);
shared Component<Input,HtmlPhrasing> u<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("u", content);
shared Component<Input,HtmlPhrasing> mark<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("mark", content);
//shared Component<Input,HtmlPhrasing> ruby<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("ruby", content);
//shared Component<Input,HtmlPhrasing> rt<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("rt", content);
//shared Component<Input,HtmlPhrasing> rp<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("rp", content);
shared Component<Input,HtmlPhrasing> bdi<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element("bdi", content);
shared Component<Input,HtmlPhrasing> bdo<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element("bdo", content);
shared Component<Input,HtmlPhrasing> span<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element("span", content);
shared Component<Input,HtmlPhrasing> br<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element("br", content);
shared Component<Input,HtmlPhrasing> wbr<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element("wbr", content);
// 4.7 Edits
shared Component<Input,HtmlPhrasing> ins<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("ins", content);
shared Component<Input,HtmlPhrasing> del<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("del", content);
// 4.8 Embedded content
shared Component<Input,HtmlPhrasing> img<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("img", content);
shared Component<Input,HtmlPhrasing> iframe<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("iframe", content);
shared Component<Input,HtmlPhrasing> embed<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("embed", content);
shared Component<Input,HtmlPhrasing> object0<in Input>({CommonContent<Input,HtmlPhrasing|HtmlParam>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("object", content);
shared Component<Input,HtmlParam> param<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlParam>("param", content);
shared Component<Input,HtmlPhrasing> video<in Input>({CommonContent<Input,HtmlPhrasing|HtmlTrack|HtmlSource>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("video", content);
shared Component<Input,HtmlPhrasing> audio<in Input>({CommonContent<Input,HtmlPhrasing|HtmlTrack|HtmlSource>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("audio", content);
shared Component<Input,HtmlSource> source<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlSource>("source", content);
shared Component<Input,HtmlTrack> track<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlTrack>("track", content);
shared Component<Input,HtmlPhrasing> canvas<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("canvas", content);
shared Component<Input,HtmlPhrasing> map<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("map", content);
shared Component<Input,HtmlPhrasing> area<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("area", content);
// 4.9 Tabular data
shared Component<Input,HtmlFlow> table<in Input>({ElementModifier<Input>|Component<Input,HtmlTableContent>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("table", content);
shared Component<Input,HtmlTableContent> caption<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlTableContent>("caption", content);
shared Component<Input,HtmlTableContent> colgroup<in Input>({ElementModifier<Input>|Component<Input,HtmlCol>*} content = empty) given Input satisfies Value => Element<Input,HtmlTableContent>("colgroup", content);
shared Component<Input,HtmlCol> col<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlCol>("col", content);
shared Component<Input,HtmlTableContent> tbody<in Input>({ElementModifier<Input>|Component<Input,HtmlTr>*} content = empty) given Input satisfies Value => Element<Input,HtmlTableContent>("tbody", content);
shared Component<Input,HtmlTableContent> thead<in Input>({ElementModifier<Input>|Component<Input,HtmlTr>*} content = empty) given Input satisfies Value => Element<Input,HtmlTableContent>("thead", content);
shared Component<Input,HtmlTableContent> tfoot<in Input>({ElementModifier<Input>|Component<Input,HtmlTr>*} content = empty) given Input satisfies Value => Element<Input,HtmlTableContent>("tfoot", content);
shared Component<Input,HtmlTr> tr<in Input>({ElementModifier<Input>|Component<Input,HtmlTd|HtmlTh>*} content = empty) given Input satisfies Value => Element<Input,HtmlTr>("tr", content);
shared Component<Input,HtmlTd> td<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlTd>("td", content);
shared Component<Input,HtmlTh> th<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlTh>("th", content);
// 4.10 Forms
shared Component<Input,HtmlFlow> form<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("form", content);
shared Component<Input,HtmlFlow> fieldset<in Input>({CommonContent<Input,HtmlFlow|HtmlLegend>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("fieldset", content);
shared Component<Input,HtmlLegend> legend<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlLegend>("legend", content);
shared Component<Input,HtmlPhrasing> label<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("label", content);
shared Component<Input,HtmlPhrasing> input<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("input", content);
shared Component<Input,HtmlPhrasing> button<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("button", content);
shared Component<Input,HtmlPhrasing> select<in Input>({ElementModifier<Input>|Component<Input,HtmlOption|HtmlOptgroup>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("select", content);
shared Component<Input,HtmlPhrasing> datalist<in Input>({CommonContent<Input,HtmlPhrasing|HtmlOption>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("datalist", content);
shared Component<Input,HtmlOptgroup> optgroup<in Input>({ElementModifier<Input>|Component<Input,HtmlOption>*} content = empty) given Input satisfies Value => Element<Input,HtmlOptgroup>("optgroup", content);
shared Component<Input,HtmlOption> option<in Input>({ElementModifier<Input>|String|OptionalStringBinding<Input,Nothing>*} content = empty) given Input satisfies Value => Element<Input,HtmlOption>("option", content);
shared Component<Input,HtmlPhrasing> textarea<in Input>({ElementModifier<Input>|String|OptionalStringBinding<Input,Nothing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("textarea", content);
shared Component<Input,HtmlPhrasing> keygen<in Input>({ElementModifier<Input>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("keygen", content);
shared Component<Input,HtmlPhrasing> output<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("output", content);
shared Component<Input,HtmlPhrasing> progress<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("progress", content);
shared Component<Input,HtmlPhrasing> meter<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlPhrasing>("meter", content);
// 4.11 Interactive ents
shared Component<Input,HtmlFlow> details<in Input>({CommonContent<Input,HtmlFlow|HtmlSummary>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("details", content);
shared Component<Input,HtmlSummary> summary<in Input>({CommonContent<Input,HtmlPhrasing>*} content = empty) given Input satisfies Value => Element<Input,HtmlSummary>("summary", content);
//shared Component<Input> menu<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("menu", content);
//shared Component<Input> menuitem<in Input>({CommonContent<Input>*} content = empty) given Input satisfies Value => Element("menuitem", content);
shared Component<Input,HtmlFlow> dialog<in Input>({CommonContent<Input,HtmlFlow>*} content = empty) given Input satisfies Value => Element<Input,HtmlFlow>("dialog", content);
