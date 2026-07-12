///|
/// Namespace used when serializing a structured markup element.
pub(all) enum MarkupNamespace {
  Html
  Svg
}

///|
/// One escaped attribute on a structured markup element.
pub(all) struct MarkupAttribute {
  name : String
  value : String
}

///|
/// A structured element. There is intentionally no raw-markup node.
pub(all) struct MarkupElement {
  kind : MarkupNamespace
  tag : String
  attributes : Array[MarkupAttribute]
  children : Array[MarkupNode]
}

///|
/// Structured export markup. Text and attributes are escaped by `serialize_markup`.
pub(all) enum MarkupNode {
  Element(MarkupElement)
  Text(String)
}

///|
pub fn markup_attribute(name : String, value : String) -> MarkupAttribute {
  { name, value }
}

///|
pub fn html_element(
  tag : String,
  attributes? : Array[MarkupAttribute] = [],
  children? : Array[MarkupNode] = [],
) -> MarkupNode {
  Element({ kind: Html, tag, attributes, children })
}

///|
pub fn svg_element(
  tag : String,
  attributes? : Array[MarkupAttribute] = [],
  children? : Array[MarkupNode] = [],
) -> MarkupNode {
  Element({ kind: Svg, tag, attributes, children })
}

///|
pub fn markup_text(value : String) -> MarkupNode {
  Text(value)
}

///|
pub fn serialize_markup(node : MarkupNode) -> String {
  let out = StringBuilder()
  serialize_markup_to(out, node)
  out.to_string()
}

///|
fn serialize_markup_to(out : StringBuilder, node : MarkupNode) -> Unit {
  match node {
    Text(value) => out.write_string(escape_markup_text(value))
    Element(element) => {
      guard is_allowed_markup_tag(element.kind, element.tag) else {
        abort("unsupported markup tag")
      }
      out.write_char('<')
      out.write_string(element.tag)
      for attribute in element.attributes {
        guard is_allowed_markup_attribute(attribute.name) else {
          abort("unsupported markup attribute")
        }
        out.write_char(' ')
        out.write_string(attribute.name)
        out.write_string("=\"")
        out.write_string(escape_markup_attribute(attribute.value))
        out.write_char('"')
      }
      if is_void_markup_tag(element.kind, element.tag) {
        out.write_string(if element.kind is Svg { " />" } else { ">" })
      } else {
        out.write_char('>')
        for child in element.children {
          serialize_markup_to(out, child)
        }
        out.write_string("</")
        out.write_string(element.tag)
        out.write_char('>')
      }
    }
  }
}

///|
fn is_allowed_markup_tag(kind : MarkupNamespace, tag : String) -> Bool {
  match kind {
    Html =>
      match tag {
        "main"
        | "div"
        | "section"
        | "article"
        | "strong"
        | "span"
        | "p"
        | "pre"
        | "code"
        | "ol"
        | "ul"
        | "li"
        | "table"
        | "thead"
        | "tbody"
        | "tr"
        | "th"
        | "td"
        | "details"
        | "summary"
        | "button"
        | "input"
        | "br"
        | "img"
        | "a"
        | "em"
        | "del"
        | "mark"
        | "sub"
        | "sup" => true
        _ => false
      }
    Svg =>
      match tag {
        "svg"
        | "g"
        | "path"
        | "line"
        | "polyline"
        | "rect"
        | "circle"
        | "ellipse"
        | "text"
        | "foreignObject" => true
        _ => false
      }
  }
}

///|
fn is_allowed_markup_attribute(name : String) -> Bool {
  if name.has_prefix("data-") || name.has_prefix("aria-") {
    return true
  }
  match name {
    "id"
    | "class"
    | "role"
    | "title"
    | "type"
    | "disabled"
    | "checked"
    | "open"
    | "hidden"
    | "href"
    | "target"
    | "rel"
    | "src"
    | "alt"
    | "loading"
    | "xmlns"
    | "width"
    | "height"
    | "viewBox"
    | "x"
    | "y"
    | "x1"
    | "x2"
    | "y1"
    | "y2"
    | "cx"
    | "cy"
    | "r"
    | "rx"
    | "ry"
    | "d"
    | "points"
    | "fill"
    | "stroke"
    | "stroke-width"
    | "stroke-linecap"
    | "stroke-linejoin"
    | "opacity"
    | "transform"
    | "preserveAspectRatio"
    | "focusable" => true
    _ => false
  }
}

///|
fn is_void_markup_tag(kind : MarkupNamespace, tag : String) -> Bool {
  match kind {
    Html => tag == "input" || tag == "br" || tag == "img"
    Svg => false
  }
}

///|
fn escape_markup_text(value : String) -> String {
  value
  .replace_all(old="&", new="&amp;")
  .replace_all(old="<", new="&lt;")
  .replace_all(old=">", new="&gt;")
}

///|
fn escape_markup_attribute(value : String) -> String {
  escape_markup_text(value)
  .replace_all(old="\"", new="&quot;")
  .replace_all(old="'", new="&#39;")
}
