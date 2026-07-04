///|
pub(all) struct SafeHtml {
  value : String
}

///|
fn safe_html_text(source : String) -> SafeHtml {
  SafeHtml::{ value: escape_html(source) }
}

///|
fn safe_html_join(parts : Array[SafeHtml]) -> SafeHtml {
  let values = []
  for part in parts {
    values.push(part.value)
  }
  SafeHtml::{ value: values.join("") }
}

///|
fn safe_html_element(
  tag : String,
  class_name~ : String,
  attrs~ : String,
  children~ : Array[SafeHtml],
) -> SafeHtml {
  let class_attr = if class_name.length() == 0 {
    ""
  } else {
    " class=\"\{escape_html_attribute(class_name)}\""
  }
  let child_html = safe_html_join(children).value
  SafeHtml::{ value: "<\{tag}\{class_attr}\{attrs}>\{child_html}</\{tag}>" }
}

///|
fn escape_html(source : String) -> String {
  source
  .replace(old="&", new="&amp;")
  .replace(old="<", new="&lt;")
  .replace(old=">", new="&gt;")
  .replace(old="\"", new="&quot;")
}

///|
fn escape_html_attribute(source : String) -> String {
  escape_html(source).replace_all(old="'", new="&#39;")
}
