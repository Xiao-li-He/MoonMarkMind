///|
pub fn render_markdown_html(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_html(@outline.build_outline(markdown), options~)
}

///|
pub fn render_markdown_svg(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_svg(@outline.build_outline(markdown), options~)
}

///|
pub fn render_outline_html(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let out = StringBuilder()
  write_outline_html(out, root, options)
  finish_builder(out)
}

///|
fn write_outline_html(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  write_str(out, "<main class=\"moonmarkmind-export moonmarkmind-export--")
  write_str(out, layout_class(options.layout))
  write_str(out, " moonmarkmind-export--")
  write_str(out, style_class(options.style))
  write_str(out, " moonmarkmind-export--")
  write_str(out, layer_to_detail_select(options.layer))
  write_str(out, "\"><div class=\"mindmap\"><div class=\"mindmap-content\">")
  write_stage(out, root, options)
  write_str(out, "</div></div></main>")
}

///|
pub fn render_outline_svg(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let out = StringBuilder()
  write_str(out, "<svg")
  write_attr(out, "xmlns", "http://www.w3.org/2000/svg")
  write_attr(out, "width", "1280")
  write_attr(out, "height", "760")
  write_attr(out, "viewBox", "0 0 1280 760")
  write_str(out, "><foreignObject")
  write_attr(out, "x", "0")
  write_attr(out, "y", "0")
  write_attr(out, "width", "1280")
  write_attr(out, "height", "760")
  write_str(out, "><div")
  write_attr(out, "xmlns", "http://www.w3.org/1999/xhtml")
  write_str(out, ">")
  write_outline_html(out, root, options)
  write_str(out, "</div></foreignObject></svg>")
  finish_builder(out)
}
